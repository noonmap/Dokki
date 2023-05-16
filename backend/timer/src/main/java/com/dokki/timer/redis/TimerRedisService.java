package com.dokki.timer.redis;


import com.dokki.timer.config.exception.CustomException;
import com.dokki.timer.repository.TimerRedisRepository;
import com.dokki.util.common.error.ErrorCode;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import org.springframework.stereotype.Service;

import java.util.List;


@Log4j2
@Service
@RequiredArgsConstructor
public class TimerRedisService {

	private final TimerRedisRepository timerRedisRepository;


	public void saveTimerList(List<Long> bookStatusIdList) {

	}


	public TimerRedisDto getTimerRedis(String id) {
		return timerRedisRepository.findById(id).orElseThrow(() -> new CustomException(ErrorCode.NOTFOUND_RESOURCE));
	}


	public void deleteTimerRedis(String id) {
		timerRedisRepository.deleteById(id);
	}

}
