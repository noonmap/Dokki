package com.dokki.book.config.exception;


import com.dokki.util.common.error.ErrorCode;
import lombok.Getter;
import lombok.RequiredArgsConstructor;


@Getter
@RequiredArgsConstructor
public class CustomException extends RuntimeException {

	private final ErrorCode errorCode;

}
