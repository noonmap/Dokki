package com.dokki.book.config.exception;


import com.dokki.util.common.error.ErrorCode;
import com.dokki.util.common.error.ErrorResponse;
import com.dokki.util.common.error.ErrorUtils;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import feign.FeignException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import java.util.Map;


@RestControllerAdvice
@RequiredArgsConstructor
@Slf4j
public class GlobalExceptionHandler {

	private final ErrorUtils errorUtils;


	/* Custom Exception */
	@ExceptionHandler(CustomException.class)
	protected ResponseEntity<ErrorResponse> handleCustomException(final CustomException e) {
		log.error("handleCustomException: {}", e.getErrorCode());
		return new ResponseEntity<>(new ErrorResponse(e.getErrorCode()), HttpStatus.valueOf(e.getErrorCode().getStatus()));
	}


	/* Feign Client Exception */
	@ExceptionHandler(FeignException.class)
	public ResponseEntity<ErrorResponse> handleFeignClientException(final FeignException e) throws JsonProcessingException {
		// responseBody가 null인 경우
		if (e.responseBody().isEmpty()) {
			log.error("handleFeignException: {}", ErrorCode.UNKNOWN_ERROR.getDescription());
			return ResponseEntity.status(ErrorCode.UNKNOWN_ERROR.getStatus()).body(new ErrorResponse(ErrorCode.UNKNOWN_ERROR));
		}

		String responseBody = e.contentUTF8();
		ObjectMapper objectMapper = new ObjectMapper();
		Map<String, Object> responseJson = objectMapper.readValue(responseBody, Map.class);
		//		log.error("[json] handleFeignException: {}", responseJson.toString());

		// ResponseBody로부터 Code와 Message를 추출
		Integer status = (Integer) responseJson.get("status");
		String code = (String) responseJson.get("code");
		String message = (String) responseJson.get("message");

		// 외부 API에서 전달한 Error가 아닌 경우, FeignException에서 발생한 status를 전달함
		if (code == null || code.isBlank()) {
			log.error("handleFeignException: [{}] {}", status, message);
			return ResponseEntity.status(status).body(new ErrorResponse(ErrorCode.UNKNOWN_ERROR));
		}

		// 외부 API에서 전달해준 Error를 전달함
		ErrorCode errorCode = errorUtils.getErrorCodeByCode(code);
		log.error("handleFeignException: [{}] {},", errorCode.getStatus(), message);
		return ResponseEntity.status(errorCode.getStatus()).body(new ErrorResponse(errorCode));
	}

}