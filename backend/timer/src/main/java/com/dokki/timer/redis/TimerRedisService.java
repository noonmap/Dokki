package com.dokki.timer.redis;


import com.dokki.timer.config.exception.CustomException;
import com.dokki.timer.repository.TimerRedisRepository;
import com.dokki.util.common.error.ErrorCode;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;


@Log4j2
@Service
@RequiredArgsConstructor

public class TimerRedisService {
	private final TimerRedisRepository timerRedisRepository;

	public void setTimerRedis(Long userId, Long bookStatusId){
		deleteTimerRedis(userId);
		timerRedisRepository.save(TimerRedis.builder()
			.userId(userId)
			.bookStatusId(bookStatusId)
			.startAt(LocalDateTime.now())
			.build());
	}
	public TimerRedis getTimerRedis(Long userId){
		return timerRedisRepository.findById(userId).orElseThrow(() -> new CustomException(ErrorCode.NOTFOUND_RESOURCE));
	}
	public void deleteTimerRedis(Long userId){
		timerRedisRepository.deleteById(userId);
	}
}
