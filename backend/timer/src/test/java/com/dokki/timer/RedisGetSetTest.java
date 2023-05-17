package com.dokki.timer;


import com.dokki.timer.redis.TimerRedis;
import com.dokki.timer.repository.TimerRedisRepository;
import lombok.extern.slf4j.Slf4j;
import org.junit.Test;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Order;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.core.ValueOperations;
import org.springframework.test.context.junit4.SpringRunner;
import static org.assertj.core.api.Assertions.*;

import java.time.LocalDateTime;
import java.util.Optional;


@Slf4j
@RunWith(SpringRunner.class)
@SpringBootTest
public class RedisGetSetTest {

	@Autowired
	private TimerRedisRepository redisRepository;

	@Test
	@DisplayName("redis timer 객체 저장 테스트")
	@Order(1)
	public void test() {
		TimerRedis timer = TimerRedis.builder()
			.userId(1L)
			.bookStatusId(1L)
			.startAt(LocalDateTime.now())
			.build();

		redisRepository.save(timer);

		Optional<TimerRedis> getTimerOptional = redisRepository.findById(timer.getUserId());
		assertThat(getTimerOptional.isPresent());

		TimerRedis getTimer = getTimerOptional.get();
		assertThat(getTimer.getUserId()).isEqualTo(1L);
		assertThat(getTimer.getBookStatusId()).isEqualTo(1L);
		assertThat(getTimer.getStartAt().isBefore(LocalDateTime.now()));
	}
}