package com.dokki.util.common.utils;


import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpHeaders;
import org.springframework.stereotype.Component;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import javax.servlet.http.HttpServletRequest;


@Component
@Slf4j
public class SessionUtils {

	static private HttpServletRequest getRequest() {
		// HttpServlet을 쓰려면spring-boot-starter-web 의존성을 추가해줘야 한다.
		return ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest();
	}


	static public String getAuthorization() {
		return getRequest().getHeader(HttpHeaders.AUTHORIZATION);
	}


	static public Long getUserId() {
		if (getRequest().getHeader("USER_ID") == null) {
			log.warn("RequestHeader \"{}\" is null", "USER_ID");
			return 0L;
		}
		return Long.valueOf(getRequest().getHeader("USER_ID"));
	}


	static public String getUserNickname() {
		if (getRequest().getHeader("USER_NICKNAME") == null) {
			log.warn("RequestHeader \"{}\" is null", "USER_NICKNAME");
			return "EMPTY";
		}
		return getRequest().getHeader("USER_NICKNAME");
	}


	static public String getUserProfileImagePath() {
		if (getRequest().getHeader("USER_PROFILE_IMAGE_PATH") == null) {
			log.warn("RequestHeader \"{}\" is null", "USER_PROFILE_IMAGE_PATH");
			return "/resources/images/default.png";
		}
		return getRequest().getHeader("USER_PROFILE_IMAGE_PATH");
	}


	static public String getRefreshToken() {
		if (getRequest().getHeader("Refresh") == null) {
			log.warn("RequestHeader \"{}\" is null", "Refresh");
			return "";
		}
		return getRequest().getHeader("Refresh");
	}

}
