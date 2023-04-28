package com.dokki.user.controller;

import io.swagger.annotations.Api;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequiredArgsConstructor
@RequestMapping("login")
@Api(tags = {"Login"},description = "로그인 관련 서비스")
@Slf4j
public class LoginController {

    @GetMapping("/oauth2/code/kakao")
    public void getCode(@RequestParam String code){
        System.out.println(code);
    }

}
