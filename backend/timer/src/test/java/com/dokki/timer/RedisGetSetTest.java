package com.dokki.timer;


import com.dokki.timer.redis.RunTimerRedisDto;
import com.dokki.timer.repository.RunTimerRedisRepository;
import lombok.extern.slf4j.Slf4j;
import org.junit.Test;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Order;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.junit4.SpringRunner;

import java.time.LocalDateTime;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;


@Slf4j
@RunWith(SpringRunner.class)
@SpringBootTest
public class RedisGetSetTest {

	@Autowired
	private RunTimerRedisRepository redisRepository;


	@Test
	@DisplayName("redis timer 객체 저장 테스트")
	@Order(1)
	public void test() {
		RunTimerRedisDto timer = RunTimerRedisDto.builder()
			.userId(1L)
			.bookStatusId(1L)
			.startAt(LocalDateTime.now())
			.build();

		redisRepository.save(timer);

		Optional<RunTimerRedisDto> getTimerOptional = redisRepository.findById(timer.getUserId());
		assertThat(getTimerOptional.isPresent());

		RunTimerRedisDto getTimer = getTimerOptional.get();
		assertThat(getTimer.getUserId()).isEqualTo(1L);
		assertThat(getTimer.getBookStatusId()).isEqualTo(1L);
		assertThat(getTimer.getStartAt().isBefore(LocalDateTime.now()));
	}

}