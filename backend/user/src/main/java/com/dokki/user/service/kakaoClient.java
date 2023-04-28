package com.dokki.user.service;

import org.springframework.cloud.openfeign.FeignClient;

@FeignClient(name="kakao-api", url = "")
public interface kakaoClient {

}
