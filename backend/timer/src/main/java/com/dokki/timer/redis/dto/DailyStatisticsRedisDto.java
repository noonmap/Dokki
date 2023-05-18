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
@RedisHash(value = "daily", timeToLive = 2 * 24 * 60 * 60)  // 2 days
public class DailyStatisticsRedisDto {

	@Id
	private String id;

	private int accumTime;
	

	public static String toIdToday(Long userId, String bookId) {
		ZonedDateTime zonedDateTime = (LocalDateTime.now()).atZone(ZoneId.of("Asia/Seoul"));
		String todayStr = zonedDateTime.toLocalDate().toString();
		return userId + ":" + todayStr + ":" + bookId;
	}


	public void updateTimerStop(int currTime) {
		this.accumTime += currTime;
	}


	public Long getUserIdFromId() {
		return Long.parseLong(this.id.split(":")[0]);
	}


	public LocalDate getDateFromId() {
		return LocalDate.parse(this.id.split(":")[1]);
	}


	public String getBookIdFromId() {
		return this.id.split(":")[2];
	}

}
