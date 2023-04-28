package com.dokki.user.service;

import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.PostMapping;

@FeignClient(name="kakao-api", url = "${spring.security.oauth2.client.registration.kakao.redirect-uri}")
public interface kakaoClient {


    @PostMapping("")
    String trance(
            
    )
}
