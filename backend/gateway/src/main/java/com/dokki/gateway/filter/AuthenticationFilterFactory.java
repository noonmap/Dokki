package com.dokki.gateway.filter;


import com.dokki.util.user.dto.response.UserSimpleInfoDto;
import lombok.extern.slf4j.Slf4j;
import org.springframework.cloud.gateway.filter.GatewayFilter;
import org.springframework.cloud.gateway.filter.factory.AbstractGatewayFilterFactory;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.server.reactive.ServerHttpRequest;
import org.springframework.stereotype.Component;
import org.springframework.web.reactive.function.client.WebClient;
import org.springframework.web.server.ServerWebExchange;


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
			log.info("[AuthorizationFilter] Request API : {}", exchange.getRequest().getPath());
			// PreProcessing
			String authHeader = exchange.getRequest().getHeaders().getFirst(HttpHeaders.AUTHORIZATION);
			if (authHeader == null) {
				log.warn("[AuthorizationFilter] AUTHORIZATION is null");
				// Authorization header가 없으면 에러 응답 반환
				exchange.getResponse().setStatusCode(HttpStatus.UNAUTHORIZED);
				return exchange.getResponse().setComplete();
			}

			return webClient.defaultHeader(HttpHeaders.AUTHORIZATION, authHeader).build().get()
				.uri("http://user-service" + "/users/auth")
				//				.header(HttpHeaders.AUTHORIZATION, authHeader)
				.retrieve()
				.bodyToMono(UserSimpleInfoDto.class)
				.doOnError(throwable -> {
					log.warn("[AuthorizationFilter] Authentication failed");
					throw new RuntimeException("[AuthorizationFilter] Authentication failed");
				})
				.flatMap(res -> {
					if (exchange.getResponse().getStatusCode().is2xxSuccessful()) {
						log.info("[AuthorizationFilter] Authentication success");
						//					log.info("[Pre Auth Filter] 실행 결과 {}", res.toString());
						// 기존 request를 복제해서 새로 붙임
						ServerHttpRequest request = exchange.getRequest().mutate()
							.header("USER_ID", String.valueOf(res.getUserId()))
							.header("USER_NICKNAME", res.getNickname())
							.header("USER_PROFILE_IMAGE_PATH", res.getProfileImagePath())
							.build();
						ServerWebExchange exchange1 = exchange.mutate().request(request).build();
						return chain.filter(exchange1);
					} else {
						log.warn("[AuthorizationFilter] Authentication failed");
						return exchange.getResponse().setComplete();
					}
				})
				//				.doOnSuccess((res) -> {
				//					log.info("[AuthorizationFilter] Authentication success");
				//					//					log.info("[Pre Auth Filter] 실행 결과 {}", res.toString());
				//					// 기존 request를 복제해서 새로 붙임
				//					ServerHttpRequest request = exchange.getRequest().mutate()
				//						.header("USER_ID", String.valueOf(res.getUserId()))
				//						.header("USER_NICKNAME", res.getNickname())
				//						.header("USER_PROFILE_IMAGE_PATH", res.getProfileImagePath())
				//						.build();
				//					ServerWebExchange exchange1 = exchange.mutate().request(request).build();
				//					return chain.filter(exchange1);
				//				})
				;

		};
	}


	public static class Config {
		// configuration properties
	}

}
