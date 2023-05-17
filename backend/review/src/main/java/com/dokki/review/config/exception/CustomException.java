package com.dokki.review.config.exception;


import com.dokki.util.common.error.ErrorCode;
import lombok.Getter;


@Getter
//@RequiredArgsConstructor
public class CustomException extends RuntimeException {

	private final ErrorCode errorCode;

	private final Integer status;
	private final String code;

	private final String message;


	public CustomException(ErrorCode errorCode) {
		this.errorCode = errorCode;
		this.status = errorCode.getStatus();
		this.code = errorCode.getCode();
		this.message = errorCode.getDescription();
	}


	public CustomException(Integer status, String message) {
		this.errorCode = ErrorCode.UNKNOWN_ERROR;
		this.status = status;
		this.code = ErrorCode.UNKNOWN_ERROR.getCode();
		this.message = message;
	}

}
