package com.dokki.timer.service;


import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;


@Component
public class Scheduler {

	@Scheduled(cron = "0/10 * * * * *")
	public void cornTest() {
		System.out.println("10초 반복");
	}

}