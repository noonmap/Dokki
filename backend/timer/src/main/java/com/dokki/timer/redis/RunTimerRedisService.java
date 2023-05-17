package com.dokki.timer.redis;


import com.dokki.timer.config.exception.CustomException;
import com.dokki.timer.repository.RunTimerRedisRepository;
import com.dokki.util.common.error.ErrorCode;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;


@Log4j2
@Service
@RequiredArgsConstructor
public class RunTimerRedisService {

	private final RunTimerRedisRepository runTimerRedisRepository;


	public RunTimerRedisDto setRunTimerRedis(Long userId, Long bookStatusId) {
		deleteRunTimerRedis(userId);
		return runTimerRedisRepository.save(RunTimerRedisDto.builder()
			.userId(userId)
			.bookStatusId(bookStatusId)
			.startAt(LocalDateTime.now())
			.build());
	}


	public RunTimerRedisDto getRunTimerRedis(Long userId) {
		return runTimerRedisRepository.findById(userId).orElseThrow(() -> new CustomException(ErrorCode.NOTFOUND_RESOURCE));
	}


	public void deleteRunTimerRedis(Long userId) {
		runTimerRedisRepository.deleteById(userId);
	}

}
