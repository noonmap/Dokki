package com.dokki.book.client;


import org.springframework.cloud.openfeign.FeignClient;


@FeignClient(name = "timer-service") // microservice name
public interface TimerClient {
}
