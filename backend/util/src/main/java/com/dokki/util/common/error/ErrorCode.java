package com.dokki.util.common.error;


import lombok.Getter;


@Getter
public enum ErrorCode {
	INVALID_REQUEST(400, "C001", "잘못된 요청입니다."),
	UNKNOWN_ERROR(400, "C002", "알 수 없는 에러"),
	NOTFOUND_RESOURCE(404, "C003", "해당 자원이 존재하지 않습니다."),

	UNAUTHORIZED(400, "U001", "로그인이 필요합니다."),
	NOT_AUTHORIZED(401, "U002", "로그인 정보를 가져올 수 없습니다."),
	EXPIRED_ACCESS_TOKEN(401, "U003", "엑세스 토큰 만료"),
	EXPIRED_REFRESH_TOKEN(401, "U004", "다시 로그인해주세요."),

	UNABLE_SEARCH(500, "B001", "검색 API를 사용할 수 없습니다.");

	private final int status;
	private final String code;
	private final String description;


	ErrorCode(int status, String code, String description) {
		this.status = status;
		this.code = code;
		this.description = description;
	}
}
