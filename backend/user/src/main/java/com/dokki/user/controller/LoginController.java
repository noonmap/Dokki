package com.dokki.user.controller;

import com.dokki.user.dto.response.KakaoResponseDto;
import com.dokki.user.dto.response.UserResponseDto;
import com.dokki.user.security.filter.JwtFilter;
import com.dokki.user.service.LoginService;
import com.fasterxml.jackson.core.JsonProcessingException;
import io.swagger.annotations.Api;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;


import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;


@RestController
@RequiredArgsConstructor
@RequestMapping("login")
@Api(tags = {"Login"},description = "로그인 관련 서비스")
@Slf4j
public class LoginController {

    private final LoginService loginService;
    @GetMapping("/oauth2/code/kakao")
    public UserResponseDto login(@RequestParam String code) throws JsonProcessingException {
        UserResponseDto userResponseDto = loginService.login(code);
        HttpHeaders httpHeaders = new HttpHeaders();
        httpHeaders.add(JwtFilter.ACCESSTOKEN_HEADER, "Bearer " + "temp");
        httpHeaders.add(JwtFilter.REFRESHTOKEN_HEADER, "Bearer " + "temp");
        return userResponseDto;
    }

}
