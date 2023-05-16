package com.dokki.user.service;


import com.dokki.user.config.exception.LogoutException;
import com.dokki.user.dto.ResponseMessage;
import com.dokki.user.dto.TokenDto;
import com.dokki.user.dto.UserDto;
import com.dokki.user.dto.request.KakaoRequestDto;
import com.dokki.user.dto.response.KakaoResponseDto;
import com.dokki.user.dto.response.UserResponseDto;
import com.dokki.user.entity.UserEntity;
import com.dokki.user.redis.RedisService;
import com.dokki.user.repository.UserRepository;
import com.dokki.user.security.SecurityUtil;
import com.dokki.user.security.jwt.TokenProvider;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonNode;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import javax.transaction.Transactional;
import java.time.LocalDateTime;
import java.util.Optional;

@RequiredArgsConstructor
@Service
@Slf4j
public class LoginService {
    private final KakaoGetAccessClient kakaoClient;
    private final KakaoGetInfoClient kakaoGetInfoClient;

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final AuthenticationManagerBuilder authenticationManagerBuilder;
    private final TokenProvider tokenProvider;

    private final RedisService redisService;

    public UserResponseDto login(String token) throws JsonProcessingException {

        /** 엑세스 토큰을 이용해서 내 정보를 받아오자 **/
        JsonNode jsonNode  = kakaoGetInfoClient.getInfo("Bearer "+token);
        String id = jsonNode.get("id").asText();
        String email = jsonNode.get("kakao_account").get("email").asText();
        String nickname = jsonNode.get("kakao_account").get("profile")
                .get("nickname").asText();
        String profileImageUrl = jsonNode.get("kakao_account").get("profile")
                .get("profile_image_url").asText();

        /**유저 Dto 객체 생성 **/
        UserDto userDto = UserDto.builder()
                .email(email)
                .nickname(nickname)
                .profileImageUrl(profileImageUrl)
                .providerId(id)
                .build();

        /** 받아온 정보를 가지고 우리 회원인지 조회 **/
        Optional<UserEntity> userEntity = userRepository.findByEmail(email);
        /** db에 없는 회원이라면 회원가입 진행 **/
        UserEntity tempUser;
        if(userEntity.orElse(null)==null) {
            log.info("가입이 필요함");
            tempUser = signUp(userDto);
        }else{
            log.info("가입된 유저");
            tempUser = userEntity.get();
        }
        UsernamePasswordAuthenticationToken authenticationToken =
                new UsernamePasswordAuthenticationToken(String.valueOf(tempUser.getId()), "kakao"+tempUser.getEmail());

        Authentication authentication = authenticationManagerBuilder.getObject().authenticate(authenticationToken);

        SecurityContextHolder.getContext().setAuthentication(authentication);

        TokenDto tokenDto = new TokenDto();
        /** 토큰 생성 */
        String accessToken = tokenProvider.createAccessToken(authentication);
        String refreshToken = tokenProvider.createRefreshToken(authentication);

        tokenDto.setAccessToken(accessToken);
        tokenDto.setRefreshToken(refreshToken);

        /** 리프레쉬 토큰 레디스 저장 */
        redisService.setValues(refreshToken, tempUser.getEmail());

        UserResponseDto userResponseDto = new UserResponseDto();
        userResponseDto.setTokenDto(tokenDto);
        userDto.setUsername(tempUser.getNickname());
        //userDto.setProfileImageUrl(fileService.getFileUrl(tempUser.getImage()));
        userDto.setUserId(tempUser.getId());
        log.info(userResponseDto.getTokenDto().getAccessToken(),userResponseDto.getTokenDto().getRefreshToken());
        userResponseDto.setUserDto(userDto);
        return userResponseDto;

    }
    public UserEntity signUp(UserDto userDto){
            UserEntity joinUser = UserEntity.builder()
                    .email(userDto.getEmail())
                    .kakaoId(userDto.getProviderId())
                    .profileImagePath(userDto.getProfileImageUrl())
                    .nickname(userDto.getNickname())
                    .followerCount(0)
                    .followingCount(0)
                    .password(passwordEncoder.encode("kakao"+userDto.getEmail()))
                    .build();
            userRepository.save(joinUser);
            return joinUser;
    }
    /** access token이 만료되기 일보 직전이라 access만 재발급할 때 */
    @Transactional
    public TokenDto refresh(String refreshToken) throws LogoutException {
        TokenDto token = new TokenDto();

        if(!tokenProvider.checkRefreshToken(refreshToken)){
            // 추후 예외 처리 예정
            return null;
        }

        Authentication authentication = tokenProvider.getAuthentication(tokenProvider.resolveToken(refreshToken));
        String accessToken = tokenProvider.createAccessToken(authentication);

        token.setAccessToken(accessToken);
        token.setRefreshToken(refreshToken.substring(7));

        return token;
    }
    /** access token이 만료됐지만 refresh token은 살아 있어서 둘다 재발급할 때 */
    @Transactional
    public TokenDto reissue(String refreshToken) throws LogoutException {
        TokenDto token = new TokenDto();

        if(!tokenProvider.checkRefreshToken(refreshToken)){
            // 추후 예외 처리 예정
            return null;
        }
        Authentication authentication = tokenProvider.getAuthentication(tokenProvider.resolveToken(refreshToken));
        redisService.delValues(tokenProvider.resolveToken(refreshToken));

        String accessToken = tokenProvider.createAccessToken(authentication);
        String newRefreshToken = tokenProvider.createRefreshToken(authentication);

        String id = SecurityUtil.getCurrentId().get();

        redisService.setValues(newRefreshToken, id);
        token.setAccessToken(accessToken);
        token.setRefreshToken(newRefreshToken);

        return token;
    }
    @Transactional
    public ResponseMessage logout(TokenDto tokenDto) throws Exception{
        ResponseMessage responseMessage = new ResponseMessage();
        String accessToken = tokenProvider.resolveToken(tokenDto.getAccessToken());
        String refreshToken = tokenProvider.resolveToken(tokenDto.getRefreshToken());

        // 토큰 유효성 검사
        if(!tokenProvider.validateToken(accessToken)){
            responseMessage.setMessage("FAIL");
        }else{
            // 토큰이 유효하다면 해당 토큰의 남은 기간과 함께 redis에 logout으로 저장
            long validExpiration = tokenProvider.getExpiration(accessToken);
            redisService.setLogoutValues(accessToken, validExpiration);

            // redis에 저장된 refresh 토큰 삭제
            if(redisService.getValues(refreshToken) != null){
                redisService.delValues(refreshToken);
            }
            responseMessage.setMessage("SUCCESS");
        }
        return responseMessage;
    }
}
