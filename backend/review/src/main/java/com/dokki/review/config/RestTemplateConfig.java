package com.dokki.review.config;


import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.web.client.RestTemplateBuilder;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpRequest;
import org.springframework.http.client.*;
import org.springframework.retry.policy.SimpleRetryPolicy;
import org.springframework.retry.support.RetryTemplate;
import org.springframework.web.client.RestTemplate;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;
import java.time.Duration;
import java.util.stream.Collectors;


@Configuration
@Slf4j
public class RestTemplateConfig {

	@Bean
	public RestTemplate restTemplate(RestTemplateBuilder builder) {
		return builder
			.setConnectTimeout(Duration.ofSeconds(5)) // 5초 timeout 설정
			.setReadTimeout(Duration.ofSeconds(10))
			.additionalInterceptors(clientHttpRequestInterceptor(), new LoggingInterceptor()) // 실패 시 retry, 로깅
			.requestFactory(() -> new BufferingClientHttpRequestFactory(new SimpleClientHttpRequestFactory())) // 응답 Stream의 데이터들이 컨슘된 상태라 데이터가 없어 에러가 발생하는 에러를 방지
			.build();
	}


	public ClientHttpRequestInterceptor clientHttpRequestInterceptor() {
		return (request, body, execution) -> {
			RetryTemplate retryTemplate = new RetryTemplate();
			retryTemplate.setRetryPolicy(new SimpleRetryPolicy(5)); // 5번까지 retry
			try {
				return retryTemplate.execute(context -> {
					log.info("Retry {}... (Exception : {})", context.getRetryCount(), context.getLastThrowable().getMessage());
					log.info("[{}] URI: {}, Method: {}, Headers:{}, Body:{} ",
						"-1", request.getURI(), request.getMethod(), request.getHeaders(), new String(body, StandardCharsets.UTF_8));
					return execution.execute(request, body);
				});
			} catch (Throwable throwable) {
				throw new RuntimeException(throwable);
			}
		};
	}


	@Slf4j
	static class LoggingInterceptor implements ClientHttpRequestInterceptor {

		@Override
		public ClientHttpResponse intercept(HttpRequest req, byte[] body, ClientHttpRequestExecution ex) throws IOException {
			final String sessionNumber = makeSessionNumber();
			printRequest(sessionNumber, req, body);
			ClientHttpResponse response = ex.execute(req, body);
			printResponse(sessionNumber, response);
			return response;
		}


		private String makeSessionNumber() {
			return Integer.toString((int) (Math.random() * 1000000));
		}


		private void printRequest(final String sessionNumber, final HttpRequest req, final byte[] body) {
			log.info("[{}] URI: {}, Method: {}, Headers:{}, Body:{} ",
				sessionNumber, req.getURI(), req.getMethod(), req.getHeaders(), new String(body, StandardCharsets.UTF_8));
		}


		private void printResponse(final String sessionNumber, final ClientHttpResponse res) throws IOException {
			String body = new BufferedReader(new InputStreamReader(res.getBody(), StandardCharsets.UTF_8)).lines()
				.collect(Collectors.joining("\n"));

			log.info("[{}] Status: {}, Headers:{}, Body:{} ",
				sessionNumber, res.getStatusCode(), res.getHeaders(), body);
		}

	}

}

