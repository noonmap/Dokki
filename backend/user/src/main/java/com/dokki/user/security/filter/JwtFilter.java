package com.dokki.user.security.filter;

import com.dokki.user.config.exception.LogoutException;
import com.dokki.util.common.error.ErrorCode;
import com.dokki.user.redis.RedisService;
import com.dokki.user.security.jwt.TokenProvider;
import io.jsonwebtoken.ExpiredJwtException;
import io.jsonwebtoken.MalformedJwtException;
import io.jsonwebtoken.UnsupportedJwtException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.util.StringUtils;
import org.springframework.web.filter.GenericFilterBean;

import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.util.Optional;

@RequiredArgsConstructor
@Slf4j
public class JwtFilter extends GenericFilterBean {

    private static final Logger LOGGER = LoggerFactory.getLogger(JwtFilter.class);
    public static final String ACCESSTOKEN_HEADER = "Authorization";
    public static final String REFRESHTOKEN_HEADER = "Refresh";

    private final TokenProvider tokenProvider;
    private final RedisService redisService;

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest httpServletRequest = (HttpServletRequest) request;
        String bearerToken = httpServletRequest.getHeader(ACCESSTOKEN_HEADER);
        String jwt = tokenProvider.resolveToken(bearerToken);
        String requestURI = httpServletRequest.getRequestURI();

        try{
            LOGGER.info("접근중 uri: {}", requestURI);
            if(StringUtils.hasText(jwt) && tokenProvider.validateToken(jwt)){
                Optional<String> isLogout = Optional.ofNullable(redisService.getValues(jwt));
                LOGGER.info("토큰검증성공 접근중 uri: {}", requestURI);
                if(!isLogout.isPresent()){
                    Authentication authentication = tokenProvider.getAuthentication(jwt);
                    SecurityContextHolder.getContext().setAuthentication(authentication);
                    LOGGER.info("Security Context에 '{}' 인증 정보를 저장했습니다, uri: {}", authentication.getName(), requestURI);
                }
                else {
                    throw new LogoutException("로그아웃");
                }
            }else{
                log.info("토큰검증실패");
            }
        }catch(io.jsonwebtoken.security.SecurityException | MalformedJwtException e){
            LOGGER.info("잘못된 JWT 서명입니다. uri: {}", requestURI);
            request.setAttribute("exception", ErrorCode.WRONG_TYPE_TOKEN.getCode());
        }catch(ExpiredJwtException e){
            LOGGER.info("만료된 JWT 토큰입니다. uri: {}", requestURI);
            request.setAttribute("exception", ErrorCode.EXPIRED_TOKEN.getCode());
        }catch(UnsupportedJwtException e){
            LOGGER.info("지원하지 않는 JWT 토큰입니다. uri: {}", requestURI);
            request.setAttribute("exception", ErrorCode.UNSUPPORTED_TOKEN.getCode());
        }catch(IllegalArgumentException e){
            LOGGER.info("JWT 토큰이 잘못되었습니다. uri: {}", requestURI);
            request.setAttribute("exception", ErrorCode.WRONG_TOKEN.getCode());
        }catch(LogoutException e){
            LOGGER.info("로그아웃된 토큰입니다. uri: {}", requestURI);
            request.setAttribute("exception", ErrorCode.LOGOUT_TOKEN.getCode());
        } catch (Exception e) {
            LOGGER.error("================================================");
            LOGGER.error("JwtFilter - doFilterInternal() 오류발생");
            LOGGER.error("token : {}", jwt);
            LOGGER.error("Exception Message : {}", e.getMessage());
            LOGGER.error("Exception StackTrace : {");
            e.printStackTrace();
            LOGGER.error("}");
            LOGGER.error("================================================");
            request.setAttribute("exception", ErrorCode.UNKNOWN_ERROR.getCode());
        }
        chain.doFilter(httpServletRequest, response);
    }
}
