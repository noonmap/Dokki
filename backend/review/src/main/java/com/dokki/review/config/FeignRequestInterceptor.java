package com.dokki.review.config;


import com.dokki.util.common.utils.SessionUtils;
import feign.RequestInterceptor;
import org.apache.http.HttpHeaders;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;


@Configuration
public class FeignRequestInterceptor {

	@Bean
	public RequestInterceptor requestInterceptor() {
		return requestTemplate -> {
			requestTemplate.header("USER_ID", String.valueOf(SessionUtils.getUserId()));
			requestTemplate.header("USER_NICKNAME", SessionUtils.getUserNickname());
			requestTemplate.header("USER_PROFILE_IMAGE_PATH", SessionUtils.getUserProfileImagePath());
			requestTemplate.header(HttpHeaders.AUTHORIZATION, SessionUtils.getAuthorization());
			requestTemplate.header("Refresh", SessionUtils.getRefreshToken());
		};
	}

}
