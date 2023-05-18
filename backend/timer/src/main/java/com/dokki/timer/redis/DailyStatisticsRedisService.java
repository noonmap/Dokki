package com.dokki.timer.redis;


import com.dokki.timer.config.exception.CustomException;
import com.dokki.timer.redis.dto.DailyStatisticsRedisDto;
import com.dokki.timer.redis.repository.DailyStatisticsRedisRepository;
import com.dokki.util.common.error.ErrorCode;
import com.google.common.collect.Lists;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import org.springframework.stereotype.Service;

import java.util.List;


@Log4j2
@Service
@RequiredArgsConstructor
public class DailyStatisticsRedisService {

	private final DailyStatisticsRedisRepository dailyStatisticsRedisRepository;


	public DailyStatisticsRedisDto createOrModifyDailyStatisticsRedis(DailyStatisticsRedisDto redisDto) {
		return dailyStatisticsRedisRepository.save(redisDto);
	}


	/**
	 * 누적시간이 0인 일일통계 데이터 추가
	 */
	public DailyStatisticsRedisDto createDailyStatisticsRedis(Long userId, String bookId) {
		return dailyStatisticsRedisRepository.save(DailyStatisticsRedisDto.builder()
			.id(DailyStatisticsRedisDto.toIdToday(userId, bookId))
			.accumTime(0)
			.build());
	}


	public boolean existTodayDailyStatisticsRedisByUserIdAndBookId(Long userId, String bookId) {
		return dailyStatisticsRedisRepository.findById(DailyStatisticsRedisDto.toIdToday(userId, bookId)).orElse(null) != null;
	}


	/**
	 * userId, bookId로 오늘 날짜 타이머 가져오기
	 */
	public DailyStatisticsRedisDto getTodayDailyStatisticsRedisByUserIdAndBookId(Long userId, String bookId) {
		return dailyStatisticsRedisRepository.findById(DailyStatisticsRedisDto.toIdToday(userId, bookId)).orElseThrow(() -> new CustomException(ErrorCode.NOTFOUND_RESOURCE));
	}


	public List<DailyStatisticsRedisDto> getListByIdIn(List<String> idList) {
		return Lists.newArrayList(dailyStatisticsRedisRepository.findAllById(idList));
	}

}
