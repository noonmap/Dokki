package com.dokki.user.error;

import lombok.Getter;

@Getter
public enum ErrorCode {
    UNKNOWN_ERROR("001","알 수 없음"),
    WRONG_TYPE_TOKEN("002", "잘못된 타입의 토큰입니다."),
    EXPIRED_TOKEN("003","만료된 토큰입니다."),
    UNSUPPORTED_TOKEN("004","지원하지않는 토큰입니다."),
    ACCESS_DENIED("005", "접근이 거부된 토큰입니다."),
    WRONG_TOKEN("006", "잘못된 토큰입니다."),
    LOGOUT_TOKEN("007", "로그아웃된 토큰입니다."),
    PLZ_RELOGIN("008", "다시 로그인 해주세요.");


    private final String code;
    private final String message;

    ErrorCode(final String code, final String message){
        this.code = code;
        this.message = message;
    }

}
