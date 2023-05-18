package com.dokki.timer.redis.dto;


import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import com.fasterxml.jackson.datatype.jsr310.deser.LocalDateTimeDeserializer;
import com.fasterxml.jackson.datatype.jsr310.ser.LocalDateTimeSerializer;
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
@RedisHash(value = "timer", timeToLive = 2 * 24 * 60 * 60)  // 2 days
public class TimerRedisDto {

	@Id
	private String id;

	private Long userId;

	private Long timerId;

	private String bookId;

	// 기존 누적시간
	private int accumTimeBefore;

	private int accumTimeToday;

	@JsonSerialize(using = LocalDateTimeSerializer.class)
	@JsonDeserialize(using = LocalDateTimeDeserializer.class)
	private LocalDate startTime;

	@JsonSerialize(using = LocalDateTimeSerializer.class)
	@JsonDeserialize(using = LocalDateTimeDeserializer.class)
	private LocalDate endTime;


	public static String toId(Long userId, Long bookStatusId, LocalDate date) {
		return userId + ":" + date + ":" + bookStatusId.toString();
	}


	public static String toIdToday(Long userId, Long bookStatusId) {
		ZonedDateTime zonedDateTime = (LocalDateTime.now()).atZone(ZoneId.of("Asia/Seoul"));
		String todayStr = zonedDateTime.toLocalDate().toString();
		return userId + ":" + todayStr + ":" + bookStatusId.toString();
	}


	public void updateTimerStop(int currTime, LocalDate endTime) {
		this.accumTimeToday += currTime;
		this.endTime = endTime;
	}


	public LocalDate getDateFromId() {
		return LocalDate.parse(this.id.split(":")[1]);
	}


	public Long getBookStatusIdFromId() {
		return Long.parseLong(this.id.split(":")[2]);
	}

}
