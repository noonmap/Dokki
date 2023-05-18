package com.dokki.gateway.filter;


import com.dokki.gateway.config.exception.CustomException;
import com.dokki.util.common.error.ErrorCode;
import com.dokki.util.user.dto.response.UserSimpleInfoDto;
import lombok.extern.slf4j.Slf4j;
import org.springframework.cloud.gateway.filter.GatewayFilter;
import org.springframework.cloud.gateway.filter.factory.AbstractGatewayFilterFactory;
import org.springframework.http.HttpHeaders;
import org.springframework.http.server.reactive.ServerHttpRequest;
import org.springframework.stereotype.Component;
import org.springframework.web.reactive.function.client.WebClient;
import org.springframework.web.server.ServerWebExchange;
import reactor.core.publisher.Mono;


@Component
@Slf4j
public class AuthenticationFilterFactory extends AbstractGatewayFilterFactory<AuthenticationFilterFactory.Config> {

	private final WebClient.Builder webClient;


	public AuthenticationFilterFactory(WebClient.Builder webClient) {
		super(Config.class);
		this.webClient = webClient;
	}


	@Override
	public GatewayFilter apply(Config config) {

		return (exchange, chain) -> {
			log.info("[AuthorizationFilter] Request API : {} {}", exchange.getRequest().getMethod(), exchange.getRequest().getPath());
			// Swagger-ui 요청 시 그냥 반환
			String[] uriPath = exchange.getRequest().getPath().toString().split("/");
			if (uriPath.length >= 4 && uriPath[2].equals("swagger-ui") && uriPath[3].startsWith("index.html")) {
				return chain.filter(exchange);
			}

			// PreProcessing
			String authHeader = exchange.getRequest().getHeaders().getFirst(HttpHeaders.AUTHORIZATION);
			if (authHeader == null) {
				log.warn("[AuthorizationFilter] AUTHORIZATION is null");
				// Authorization header가 없으면 에러 응답 반환
				//				exchange.getResponse().setStatusCode(HttpStatus.UNAUTHORIZED);
				//				return exchange.getResponse().setComplete();
				return Mono.error(new CustomException(ErrorCode.UNAUTHORIZED));
			}

			return webClient.defaultHeader(HttpHeaders.AUTHORIZATION, authHeader).build().get()
				.uri("http://user-service" + "/users/auth")
				//				.header(HttpHeaders.AUTHORIZATION, authHeader)
				.retrieve()
				.bodyToMono(UserSimpleInfoDto.class)
				.doOnError(throwable -> {
					log.warn("[AuthorizationFilter] Authentication failed");
					throw new CustomException(ErrorCode.ACCESS_DENIED);
				})
				.flatMap(res -> {
					log.info("[AuthorizationFilter] Authentication success");
					//					log.info("[Pre Auth Filter] 실행 결과 {}", res.toString());
					// 기존 request를 복제해서 새로 붙임
					ServerHttpRequest request = exchange.getRequest().mutate()
						.header("USER_ID", String.valueOf(res.getUserId()))
						.header("USER_NICKNAME", res.getNickname())
						.header("USER_PROFILE_IMAGE_PATH", res.getProfileImagePath())
						.header(HttpHeaders.AUTHORIZATION, exchange.getRequest().getHeaders().getFirst(HttpHeaders.AUTHORIZATION))
						.header("Refresh", exchange.getRequest().getHeaders().getFirst("Refresh"))
						.build();
					ServerWebExchange exchange1 = exchange.mutate().request(request).build();
					return chain.filter(exchange1);
				});
		};
	}


	public static class Config {
		// configuration properties
	}

}
