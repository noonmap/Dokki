package com.dokki.app.config;


import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import springfox.documentation.builders.ApiInfoBuilder;
import springfox.documentation.builders.PathSelectors;
import springfox.documentation.builders.RequestHandlerSelectors;
import springfox.documentation.service.ApiInfo;
import springfox.documentation.spi.DocumentationType;
import springfox.documentation.spring.web.plugins.Docket;
import springfox.documentation.swagger2.annotations.EnableSwagger2;

import java.util.HashSet;
import java.util.Set;


@Configuration
@EnableSwagger2
public class SwaggerConfig {

	@Bean
	public Docket api() {
		return new Docket(DocumentationType.SWAGGER_2)
			.apiInfo(apiInfo())
			.consumes(getConsumeContentTypes())
			.produces(getProduceContentTypes())
			.select()
			.apis(RequestHandlerSelectors.basePackage("com.dokki.app"))
			.paths(PathSelectors.ant("/api/**"))
			.build();
	}


	private ApiInfo apiInfo() {
		return new ApiInfoBuilder()
			.title("[ DOKKI ] APP API SERVER")
			.version("0.0.1")
			.description("DOKKI 앱 - APP API 서버 \nport: 5000")
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

}
