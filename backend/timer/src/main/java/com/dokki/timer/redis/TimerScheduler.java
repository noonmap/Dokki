package com.dokki.timer.redis;


import com.dokki.timer.entity.DailyStatisticsEntity;
import com.dokki.timer.redis.dto.DailyStatisticsRedisDto;
import com.dokki.timer.redis.dto.TimerRedisDto;
import com.dokki.timer.repository.DailyStatisticsRepository;
import com.dokki.timer.repository.TimerRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.stream.Collectors;


@Component
@Log4j2
@RequiredArgsConstructor
public class TimerScheduler {

	private final TimerRepository timerRepository;
	private final DailyStatisticsRepository dailyStatisticsRepository;
	private final RedisTempleteService redisTempleteService;
	private final TimerRedisService timerRedisService;
	private final DailyStatisticsRedisService dailyStatisticsRedisService;


	/**
	 * 전날 타이머 데이터 db 업데이트
	 * Write Back
	 */
	@Scheduled(cron = "0 0 4 * * *")    // 매일 AM 4시
	public void updateDB() {
		log.info("[timer scheduler] start");
		List<String> idListYesterday = redisTempleteService.getTimerIdListPastData(1);
		List<String> statisticsIdListYesterday = redisTempleteService.getDailyStatisticsIdListPastData(1);
		List<TimerRedisDto> timerRedisDtoList = timerRedisService.getListByIdIn(idListYesterday);
		List<DailyStatisticsRedisDto> dailyStatisticsRedisDtoList = dailyStatisticsRedisService.getListByIdIn(statisticsIdListYesterday);

		// 타이머 update
		timerRedisDtoList.forEach(o -> timerRepository.updateAccumTimeAndEndTime(o.getAccumTimeToday(), o.getEndTime(), o.getTimerId()));

		// 통계 save
		dailyStatisticsRepository.saveAllAndFlush(dailyStatisticsRedisDtoList.stream().filter(o -> o.getAccumTime() != 0).map(o -> DailyStatisticsEntity.builder()
			.userId(o.getUserIdFromId())
			.accumTime(o.getAccumTime())
			.bookId(o.getBookIdFromId())
			.recordDate(o.getDateFromId())
			.build()).collect(Collectors.toList()));

		log.debug("timer redis updated id - {}", idListYesterday);
		log.info("[timer scheduler] done");
	}

}