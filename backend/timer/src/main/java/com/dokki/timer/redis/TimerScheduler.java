package com.dokki.timer.redis;


import com.dokki.timer.entity.DailyStatisticsEntity;
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
	private final TimerRedisTempleteService timerRedisTempleteService;
	private final TimerRedisService timerRedisService;


	/**
	 * 전날 타이머 데이터 db 업데이트
	 * Write Back
	 */
	@Scheduled(cron = "0 0 5 * * *")
	public void updateDB() {
		log.info("[timer scheduler] start");
		List<String> idListYesterday = timerRedisTempleteService.getIdListPastData(1);
		List<TimerRedisDto> timerRedisDtoList = timerRedisService.getListByIdIn(idListYesterday);

		// 타이머 update
		timerRedisDtoList.forEach(o -> timerRepository.updateAccumTime(o.getAccumTimeToday(), o.getEndTime(), o.getTimerId()));

		// 통계 save
		dailyStatisticsRepository.saveAllAndFlush(timerRedisDtoList.stream().filter(o -> o.getAccumTimeToday() != 0).map(o -> DailyStatisticsEntity.builder()
			.userId(o.getUserId())
			.accumTime(o.getAccumTimeToday())
			.bookId(o.getBookId())
			.recordDate(o.getDateFromId())
			.build()).collect(Collectors.toList()));

		log.info("[timer scheduler] done");
	}

}