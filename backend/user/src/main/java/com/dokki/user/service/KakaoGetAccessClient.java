package com.dokki.user.service;

import com.dokki.user.dto.response.KakaoResponseDto;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.stereotype.Component;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;

@FeignClient(name="kakao-api", url = "https://kauth.kakao.com/oauth/token")
@Component
public interface KakaoGetAccessClient {

    @PostMapping(value = "",headers = "Content-type=application/x-www-form-urlencoded;charset=utf-8")
    KakaoResponseDto getAcessToken(@RequestBody String kakaoReq);

}
