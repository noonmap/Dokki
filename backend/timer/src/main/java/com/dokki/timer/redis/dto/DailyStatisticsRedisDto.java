package com.dokki.timer.redis.dto;


import lombok.*;
import org.springframework.data.annotation.Id;
import org.springframework.data.redis.core.RedisHash;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.ZonedDateTime;


@ToString
@Getter
@NoArgsConstructor
@AllArgsConstructor(access = AccessLevel.PRIVATE)
@Builder
@RedisHash(value = "daily_statistics", timeToLive = 2 * 24 * 60 * 60)  // 2 days
public class DailyStatisticsRedisDto {

	@Id
	private String id;

	private int accumTime;


	public static String toId(Long userId, Long bookStatusId, LocalDate date) {
		return userId + ":" + date + ":" + bookStatusId.toString();
	}


	public static String toIdToday(Long userId, String bookId) {
		ZonedDateTime zonedDateTime = (LocalDateTime.now()).atZone(ZoneId.of("Asia/Seoul"));
		String todayStr = zonedDateTime.toLocalDate().toString();
		return userId + ":" + todayStr + ":" + bookId;
	}


	public void updateTimerStop(int currTime, LocalDate endTime) {
		this.accumTime += currTime;
	}


	public LocalDate getDateFromId() {
		return LocalDate.parse(this.id.split(":")[1]);
	}


	public String getBookIdFromId() {
		return this.id.split(":")[2];
	}

}
