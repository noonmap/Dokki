package com.dokki.timer.config;


import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import springfox.documentation.builders.ApiInfoBuilder;
import springfox.documentation.builders.PathSelectors;
import springfox.documentation.builders.RequestHandlerSelectors;
import springfox.documentation.service.ApiInfo;
import springfox.documentation.service.ApiKey;
import springfox.documentation.service.AuthorizationScope;
import springfox.documentation.service.SecurityReference;
import springfox.documentation.spi.DocumentationType;
import springfox.documentation.spi.service.contexts.SecurityContext;
import springfox.documentation.spring.web.plugins.Docket;
import springfox.documentation.swagger2.annotations.EnableSwagger2;

import java.util.Arrays;
import java.util.HashSet;
import java.util.List;
import java.util.Set;


@Configuration
@EnableSwagger2
public class SwaggerConfig {

	@Bean
	public Docket api() {
		return new Docket(DocumentationType.SWAGGER_2)
			.apiInfo(apiInfo())
			.useDefaultResponseMessages(false)
			.securityContexts(Arrays.asList(securityContext()))
			.securitySchemes(Arrays.asList(apiKey()))
			.consumes(getConsumeContentTypes())
			.produces(getProduceContentTypes())
			.select()
			.apis(RequestHandlerSelectors.basePackage("com.dokki.timer"))
			.paths(PathSelectors.ant("/**"))
			.build();
	}


	private ApiInfo apiInfo() {
		return new ApiInfoBuilder()
			.title("[ DOKKI ] TIMER API SERVER")
			.version("0.0.1")
			.description("DOKKI 앱 - TIMER API 서버")
			.build();
	}


	private Set<String> getConsumeContentTypes() {
		Set<String> consumes = new HashSet<>();
		consumes.add("application/json;charset=UTF-8");
		consumes.add("application/x-www-form-urlencoded");
		return consumes;
	}


	private Set<String> getProduceContentTypes() {
		Set<String> produces = new HashSet<>();
		produces.add("application/json;charset=UTF-8");
		return produces;
	}


	private ApiKey apiKey() {
		return new ApiKey("Authorization", "Authorization", "header");
	}


	private SecurityContext securityContext() {
		return springfox
			.documentation
			.spi.service
			.contexts
			.SecurityContext
			.builder()
			.securityReferences(defaultAuth()).forPaths(PathSelectors.any()).build();
	}


	List<SecurityReference> defaultAuth() {
		AuthorizationScope authorizationScope = new AuthorizationScope("global", "accessEverything");
		AuthorizationScope[] authorizationScopes = new AuthorizationScope[1];
		authorizationScopes[0] = authorizationScope;
		return Arrays.asList(new SecurityReference("JWT", authorizationScopes));
	}

}
