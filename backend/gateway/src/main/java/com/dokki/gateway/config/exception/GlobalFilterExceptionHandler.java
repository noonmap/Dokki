package com.dokki.gateway.config.exception;


import com.dokki.util.common.error.ErrorCode;
import com.dokki.util.common.error.ErrorResponse;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.web.reactive.error.ErrorWebExceptionHandler;
import org.springframework.core.annotation.Order;
import org.springframework.core.io.buffer.DataBuffer;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.server.reactive.ServerHttpResponse;
import org.springframework.stereotype.Component;
import org.springframework.web.server.ServerWebExchange;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

import java.nio.charset.StandardCharsets;


@Component
@RequiredArgsConstructor
@Order(-1)
@Slf4j
public class GlobalFilterExceptionHandler implements ErrorWebExceptionHandler {

	private final ObjectMapper objectMapper;


	@Override
	public Mono<Void> handle(ServerWebExchange exchange, Throwable ex) {
		ServerHttpResponse response = exchange.getResponse();

		if (response.isCommitted()) {
			return Mono.error(ex);
		}

		response.getHeaders().setContentType(MediaType.APPLICATION_JSON);
		CustomException customEx;

		if (ex instanceof CustomException) { // Custom Exception이 throw 된 경우
			customEx = (CustomException) ex;
		} else { // Custom Exception이 throw 되지 않은 경우
			customEx = new CustomException(ErrorCode.UNKNOWN_GATEWAY_ERROR);
		}
		response.setStatusCode(HttpStatus.valueOf(customEx.getStatus()));
		String error = "Gateway Error";
		try {
			// ErrorCode를 다른 ExceptionHandler처럼 가공
			//			error = objectMapper.writerWithDefaultPrettyPrinter().writeValueAsString(new ErrorResponse(customEx.getErrorCode()));
			error = objectMapper.writeValueAsString(new ErrorResponse(customEx.getErrorCode()));
			log.error("[GlobalFilterExceptionHandler] {}", error);
		} catch (JsonProcessingException e) {
			log.error("JsonProcessingException : " + e.getMessage());
		}

		byte[] bytes = error.getBytes(StandardCharsets.UTF_8);
		DataBuffer buffer = exchange.getResponse().bufferFactory().wrap(bytes);
		return exchange.getResponse().writeWith(Flux.just(buffer));
	}

}
