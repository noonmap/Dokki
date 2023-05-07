package com.dokki.timer;


import com.dokki.timer.redis.Timer;
import lombok.extern.slf4j.Slf4j;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.core.ValueOperations;
import org.springframework.test.context.junit4.SpringRunner;
import static org.assertj.core.api.Assertions.*;

import java.time.LocalDateTime;


@Slf4j
@RunWith(SpringRunner.class)
@SpringBootTest
public class RedisGetSetTest {
	@Autowired
	RedisTemplate<String,Object> redisTemplate;

	@Test
	public void test() {
		ValueOperations<String,Object> vop = redisTemplate.opsForValue();

		Timer timer = new Timer();
		timer.setBookStatusId(1L);
		timer.setStartAt(LocalDateTime.now());

		vop.set("test",timer);

		Timer getTimer = (Timer) vop.get("test");
		assert getTimer != null;
		assertThat(getTimer.getBookStatusId()).isEqualTo(1L);
		assertThat(getTimer.getStartAt().isBefore(LocalDateTime.now()));
	}
}