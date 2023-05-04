package com.dokki.book.config;


import com.dokki.util.common.error.ErrorUtils;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;


@Configuration
public class ExceptionConfig {

	@Bean
	public ErrorUtils errorUtils() {
		return new ErrorUtils();
	}

}
