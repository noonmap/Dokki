package com.dokki.util.common.error;


import lombok.Getter;


@Getter
public class ErrorResponse {

	private final String code;
	private final String message;


	public ErrorResponse(ErrorCode e) {
		this.code = e.getCode();
		this.message = e.getDescription();
	}

}
