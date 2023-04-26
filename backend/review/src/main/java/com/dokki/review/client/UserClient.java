package com.dokki.review.client;


import org.springframework.cloud.openfeign.FeignClient;


@FeignClient(name = "user-service")
public interface UserClient {

	/**
	 * 유저 간단 조회 정보
	 */
	// TODO : user api 목업 추가 후, 메소드 추가하기

}
