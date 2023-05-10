package com.dokki.util.common.utils;


import org.springframework.stereotype.Component;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import javax.servlet.http.HttpServletRequest;


@Component
public class SessionUtils {

	static private HttpServletRequest getRequest() {
		// HttpServlet을 쓰려면spring-boot-starter-web 의존성을 추가해줘야 한다.
		return ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest();
	}


	static public Long getUserId() {
		if (getRequest().getHeader("USER_ID") == null) {
			return 0L;
		}
		return Long.valueOf(getRequest().getHeader("USER_ID"));
	}


	static public String getUserNickname() {
		if (getRequest().getHeader("USER_NICKNAME") == null) {
			return "EMPTY";
		}
		return getRequest().getHeader("USER_NICKNAME");
	}


	static public String getUserProfileImagePath() {
		if (getRequest().getHeader("USER_PROFILE_IMAGE_PATH") == null) {
			return "/resources/images/default.png";
		}
		return getRequest().getHeader("USER_PROFILE_IMAGE_PATH");
	}

}
