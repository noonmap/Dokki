package com.dokki.timer.redis;


import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import com.fasterxml.jackson.databind.deser.std.NumberDeserializers;
import com.fasterxml.jackson.databind.ser.std.BooleanSerializer;
import com.fasterxml.jackson.datatype.jsr310.deser.LocalDateTimeDeserializer;
import com.fasterxml.jackson.datatype.jsr310.ser.LocalDateTimeSerializer;
import lombok.*;
import org.springframework.data.annotation.Id;
import org.springframework.data.redis.core.RedisHash;

import java.time.LocalDate;


@Getter
@NoArgsConstructor
@AllArgsConstructor(access = AccessLevel.PRIVATE)
@Builder
@RedisHash(value = "timer", timeToLive = 24 * 60 * 60)
public class TimerRedisDto {

	@Id
	private Long bookStatusId;

	private Long userId;

	private Long id;

	// 기존 누적시간
	private int accumTimeBefore;

	private int accumTimeToday;

	@JsonSerialize(using = LocalDateTimeSerializer.class)
	@JsonDeserialize(using = LocalDateTimeDeserializer.class)
	private LocalDate endTime;

	@JsonSerialize(using = BooleanSerializer.class)
	@JsonDeserialize(using = NumberDeserializers.BooleanDeserializer.class)
	private boolean isExistInDB;

}
