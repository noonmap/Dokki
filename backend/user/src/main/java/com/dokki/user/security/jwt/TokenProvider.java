package com.dokki.user.security.jwt;

import io.jsonwebtoken.*;
import io.jsonwebtoken.security.Keys;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.InitializingBean;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.stereotype.Component;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.util.StringUtils;

import java.security.Key;
import java.util.*;
import java.util.stream.Collectors;

@Component
public class TokenProvider implements InitializingBean {
    private final Logger LOGGER = LoggerFactory.getLogger(TokenProvider.class);
    private static final String AUTHORITIES_KEY = "DOKKIAPI";

    private final String secret;
    private final long accessTokenExpiration;
    private final long refreshTokenExpiration;
    private final String accessHeader;
    private final String refreshHeader;

    private Key key;

    public TokenProvider(
            @Value("${jwt.secret}") String secret,
            @Value("${jwt.access.expiration}") long accessTokenExpiration,
            @Value("${jwt.refresh.expiration}") long refreshTokenExpiration,
            @Value("${jwt.access.header}") String accessHeader,
            @Value("${jwt.refresh.header}") String refreshHeader){
        this.secret = secret;
        this.accessTokenExpiration = accessTokenExpiration;
        this.refreshTokenExpiration = refreshTokenExpiration;
        this.accessHeader = accessHeader;
        this.refreshHeader = refreshHeader;
    }

    @Override
    public void afterPropertiesSet() throws Exception {
        byte[] keyBytes = Base64.getDecoder().decode(secret);
        this.key = Keys.hmacShaKeyFor(keyBytes);
    }

    /**Access token 생성 algorithm */
    public String createAccessToken(Authentication authentication){
        String authorities = authentication.getAuthorities().stream()
                .map(GrantedAuthority::getAuthority)
                .collect(Collectors.joining(","));
        long now = (new Date()).getTime();
        Date validity = new Date(now + this.accessTokenExpiration);

        return Jwts.builder()
                .setSubject(authentication.getName())
                .setIssuedAt(new Date())
                .claim(AUTHORITIES_KEY, authorities)
                .signWith(key, SignatureAlgorithm.HS512)
                .setExpiration(validity)
                .compact();
    }
    /**Refresh token 생성 algorithm */
    public String createRefreshToken(Authentication authentication){
        String authorities = authentication.getAuthorities().stream()
                .map(GrantedAuthority::getAuthority)
                .collect(Collectors.joining(","));
        long now = (new Date()).getTime();
        Date validity = new Date(now + this.refreshTokenExpiration);

        String token = Jwts.builder()
                .setSubject(authentication.getName())
                .setIssuedAt(new Date())
                .claim(AUTHORITIES_KEY, authorities)
                .signWith(key, SignatureAlgorithm.HS512)
                .setExpiration(validity)
                .compact();
        LOGGER.info("RefreshToken이 생성되었습니다.");

        return token;
    }

    /** access token 재발급 체크 */
    public boolean checkRefreshToken(String refreshToken){ //throws LogoutException {

        String token = resolveToken(refreshToken);

        //Optional<String> email = Optional.ofNullable(redisService.getValues(token));

//        if(!email.isPresent()){
//            LOGGER.info("refreshToken이 존재하지 않습니다.");
//            throw new LogoutException("리프레쉬 만료 다시 로그인 해주세요.");
//        }

        try{
            Jwts.parserBuilder().setSigningKey(key).build().parseClaimsJws(token);
            LOGGER.info("refreshToken이 만료되지 않았습니다.");
            return true;
        }catch (ExpiredJwtException e) {
            LOGGER.info("refreshToken이 만료되었습니다. 다시 로그인 해주세요.");
            return false;
        }catch (Exception e){
            LOGGER.error("refreshToken 재발급중 에러각 발생했습니다.: {}", e.getMessage());
            return false;
        }
    }


    /** 인증 정보 조회 **/
    public Authentication getAuthentication(String token) {
        Claims claims = Jwts.parserBuilder()
                .setSigningKey(key)
                .build()
                .parseClaimsJws(token)
                .getBody();
        Collection<? extends GrantedAuthority> authorities =
                Arrays.stream(claims.get(AUTHORITIES_KEY).toString().split(","))
                        .map(SimpleGrantedAuthority::new)
                        .collect(Collectors.toList());
        User principal =new User(claims.getSubject(), "", authorities);
        return new UsernamePasswordAuthenticationToken(principal, token, authorities);
    }
    /** 토큰 유효성 검증 **/
    public boolean validateToken(String token) throws Exception{
        try{
            Jwts.parserBuilder().setSigningKey(key).build().parseClaimsJws(token);
            return true;
        } catch(io.jsonwebtoken.security.SecurityException | MalformedJwtException e){
            LOGGER.info("잘못된 JWT 서명입니다.");
        } catch(ExpiredJwtException e){
            LOGGER.info("만료된 JWT 토큰입니다.");
        } catch(UnsupportedJwtException e){
            LOGGER.info("지원되지 않는 JWT 토큰입니다.");
        } catch(IllegalArgumentException e){
            LOGGER.info("JWT 토큰이 잘못되었습니다.");
        }
        return false;
    }
    /**토큰 정보 추출 */
    public String resolveToken(String bearerToken){

//        String bearerToken = request.getHeader("Authorization");
        if(StringUtils.hasText(bearerToken) && bearerToken.startsWith("Bearer ")){
            return bearerToken.substring(7);
        }
        return null;
    }

    public Long getExpiration(String accessToken){
        Date expiration = Jwts.parserBuilder().setSigningKey(key).build().parseClaimsJws(accessToken).getBody().getExpiration();
        Long now = new Date().getTime();
        return (expiration.getTime() - now);
    }



}
