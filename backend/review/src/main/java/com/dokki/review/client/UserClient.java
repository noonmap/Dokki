package com.dokki.review.client;


import com.dokki.util.user.dto.response.UserSimpleInfoDto;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;

import java.util.List;


@FeignClient(name = "user-service")
public interface UserClient {

	/**
	 * 유저 간단 조회 정보
	 */
	@PostMapping("/users/profile/simple")
	List<UserSimpleInfoDto> getUserSimpleInfo(@RequestBody List<Long> userIdList);

}
