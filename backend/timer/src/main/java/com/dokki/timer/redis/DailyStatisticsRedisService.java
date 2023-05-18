package com.dokki.timer.redis;


import com.dokki.timer.config.exception.CustomException;
import com.dokki.timer.redis.dto.DailyStatisticsRedisDto;
import com.dokki.timer.redis.repository.DailyStatisticsRedisRepository;
import com.dokki.util.common.error.ErrorCode;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import org.springframework.stereotype.Service;


@Log4j2
@Service
@RequiredArgsConstructor
public class DailyStatisticsRedisService {

	private final DailyStatisticsRedisRepository dailyStatisticsRedisRepository;


	public DailyStatisticsRedisDto createDailyStatisticsRedis(DailyStatisticsRedisDto redisDto) {
		return dailyStatisticsRedisRepository.save(redisDto);
	}


	public DailyStatisticsRedisDto createDailyStatisticsRedis(Long userId, String bookId) {
		return dailyStatisticsRedisRepository.save(DailyStatisticsRedisDto.builder()
			.id(DailyStatisticsRedisDto.toIdToday(userId, bookId))
			.accumTime(0)
			.build());
	}


	public DailyStatisticsRedisDto getDailyStatisticsRedis(String id) {
		return dailyStatisticsRedisRepository.findById(id).orElseThrow(() -> new CustomException(ErrorCode.NOTFOUND_RESOURCE));
	}

}
