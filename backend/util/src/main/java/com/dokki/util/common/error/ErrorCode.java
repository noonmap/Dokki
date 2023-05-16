package com.dokki.util.common.error;


import lombok.Getter;


@Getter
public enum ErrorCode {
	INVALID_REQUEST(400, "C001", "잘못된 요청입니다."),
	UNKNOWN_ERROR(400, "C002", "알 수 없는 에러"),
	NOTFOUND_RESOURCE(404, "C003", "해당 자원이 존재하지 않습니다."),
	DUPLICATE_RESOURCE(409, "C004", "이미 존재하는 데이터입니다."),
	UNKNOWN_GATEWAY_ERROR(400, "C005", "Gateway에서 발생한 에러"),

	UNAUTHORIZED(400, "U001", "로그인이 필요합니다."),
	WRONG_TYPE_TOKEN(400,"U002", "잘못된 타입의 토큰입니다."),
	EXPIRED_TOKEN(401,"U003","만료된 토큰입니다."),
	UNSUPPORTED_TOKEN(401,"U004","지원하지않는 토큰입니다."),
	ACCESS_DENIED(401,"U005", "접근이 거부된 토큰입니다."),
	WRONG_TOKEN(401,"U006", "잘못된 토큰입니다."),
	LOGOUT_TOKEN(401,"U007", "로그아웃된 토큰입니다."),
	PLZ_RELOGIN(401,"U008", "다시 로그인 해주세요."),


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
