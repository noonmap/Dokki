package com.dokki.gateway.config;


import com.dokki.gateway.config.exception.GlobalFilterExceptionHandler;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;


@Configuration
@RequiredArgsConstructor
public class ExceptionConfig {

	private final ObjectMapper objectMapper;


	@Bean
	public GlobalFilterExceptionHandler globalFilterExceptionHandler() {
		return new GlobalFilterExceptionHandler(objectMapper);
	}

}
