package com.dokki.review;


import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.client.discovery.EnableDiscoveryClient;
import org.springframework.cloud.openfeign.EnableFeignClients;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.data.jpa.repository.config.EnableJpaAuditing;

import javax.annotation.PostConstruct;
import java.time.LocalDateTime;
import java.util.TimeZone;


@SpringBootApplication
@EnableFeignClients
@EnableDiscoveryClient
@EnableJpaAuditing // created, updated 관련
@Slf4j
@ComponentScan(basePackages = { "com.dokki.util" }) // FileUtils 빈 의존성
public class ReviewApplication {

	public static void main(String[] args) {
		SpringApplication.run(ReviewApplication.class, args);
	}


	@PostConstruct
	void started() {
		TimeZone.setDefault(TimeZone.getTimeZone("Asia/Seoul"));
		log.info("Current Time : {}", LocalDateTime.now());
	}

}
