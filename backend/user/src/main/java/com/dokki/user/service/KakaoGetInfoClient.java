package com.dokki.user.service;

import com.dokki.user.dto.response.KakaoInfoResponseDto;
import com.dokki.user.dto.response.KakaoResponseDto;
import com.fasterxml.jackson.databind.JsonNode;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.stereotype.Component;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestParam;

@FeignClient(name="kakao-infoApi", url = "https://kapi.kakao.com/v2/user/me")
@Component
public interface KakaoGetInfoClient {

    @PostMapping(value = "",headers = "Content-type=application/x-www-form-urlencoded;charset=utf-8")
    JsonNode getInfo(@RequestHeader(name = "Authorization") String Authorization);

}
