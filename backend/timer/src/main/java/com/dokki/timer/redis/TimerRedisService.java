package com.dokki.timer.redis;


import com.dokki.timer.config.exception.CustomException;
import com.dokki.timer.entity.TimerEntity;
import com.dokki.timer.redis.dto.DailyStatisticsRedisDto;
import com.dokki.timer.redis.dto.TimerRedisDto;
import com.dokki.timer.redis.dto.TodayAccessRedisDto;
import com.dokki.timer.redis.repository.DailyStatisticsRedisRepository;
import com.dokki.timer.redis.repository.TimerRedisRepository;
import com.dokki.timer.redis.repository.TodayAccessRedisRepository;
import com.dokki.timer.repository.TimerRepository;
import com.dokki.util.common.error.ErrorCode;
import com.google.common.collect.Lists;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.List;
import java.util.Objects;
import java.util.stream.Collectors;


@Log4j2
@Service
@RequiredArgsConstructor
public class TimerRedisService {

	private final TimerRepository timerRepository;
	private final TodayAccessRedisRepository todayAccessRedisRepository;
	private final TimerRedisRepository timerRedisRepository;
	private final DailyStatisticsRedisRepository dailyStatisticsRedisRepository;


	/**
	 * 레디스에 타이머 하나 추가
	 */
	public TimerRedisDto createOrModifyTimerRedis(TimerRedisDto timerRedisDto) {
		return timerRedisRepository.save(timerRedisDto);
	}


	/**
	 * 레디스에 타이머 하나 추가
	 */
	public TimerRedisDto createOrModifyTimerRedis(TimerEntity timer) {
		return timerRedisRepository.save(TimerRedisDto.builder()
			.bookId(timer.getBookId())
			.timerId(timer.getId())
			.startTime(timer.getStartTime())
			.endTime(timer.getEndTime())
			.accumTimeBefore(timer.getAccumTime())
			.userId(timer.getUserId())
			.id(TimerRedisDto.toIdToday(timer.getUserId(), timer.getBookStatusId()))
			.build());
	}


	/**
	 * 오늘 첫 방문시 레디스에 해당유저의 타이머 정보 저장
	 */
	public List<TimerRedisDto> createTimerRedisListByTodayFirstAccess(Long userId, List<Long> bookStatusIdList) {
		List<TimerRedisDto> resultList;
		List<TimerEntity> timerEntityList = timerRepository.findByBookStatusIdIn(bookStatusIdList);

		// 타이머 정보로 당일 타이머 저장
		resultList = Lists.newArrayList(timerRedisRepository.saveAll(
			timerEntityList.stream().map(e ->
				TimerRedisDto.builder()
					.bookId(e.getBookId())
					.timerId(e.getId())
					.startTime(e.getStartTime())
					.endTime(e.getEndTime())
					.accumTimeBefore(e.getAccumTime())
					.userId(userId)
					.id(TimerRedisDto.toIdToday(userId, e.getBookStatusId()))
					.build()).collect(Collectors.toList())));

		// 타이머 정보로 당일 통계 저장
		dailyStatisticsRedisRepository.saveAll(timerEntityList.stream().map(e ->
			DailyStatisticsRedisDto.builder()
				.id(DailyStatisticsRedisDto.toIdToday(userId, e.getBookId()))
				.build()).collect(Collectors.toList()));

		// 오늘 방문 여부 (timer 저장 여부) 추가
		todayAccessRedisRepository.save(TodayAccessRedisDto.builder()
			.userId(userId)
			.accessDate(LocalDate.now())
			.build());

		return resultList;
	}


	/**
	 * id로 타이머 가져오기
	 */
	public TimerRedisDto getTimerRedis(String id) {
		return timerRedisRepository.findById(id).orElseThrow(() -> new CustomException(ErrorCode.NOTFOUND_RESOURCE));
	}


	/**
	 * bookStatusId로 오늘 날짜 타이머 가져오기
	 */
	public TimerRedisDto getTimerRedisByTodayAndBookStatusId(Long userId, Long bookStatusId) {
		return timerRedisRepository.findById(TimerRedisDto.toIdToday(userId, bookStatusId)).orElseThrow(() -> new CustomException(ErrorCode.NOTFOUND_RESOURCE));
	}


	public void deleteTimerRedis(String id) {
		timerRedisRepository.deleteById(id);
	}


	/**
	 * 오늘 첫 방문인지 체크
	 */
	public boolean todayFirstAccess(Long userId) {
		TodayAccessRedisDto todayAccess = todayAccessRedisRepository.findById(userId).orElse(null);
		return todayAccess == null || !Objects.equals(LocalDate.now(), todayAccess.getAccessDate());
	}


	/**
	 * id 리스트로 타이머 리스트 가져오기
	 */
	public List<TimerRedisDto> getListByIdIn(List<String> idList) {
		return Lists.newArrayList(timerRedisRepository.findAllById(idList));
	}


	/**
	 * bookStatusId로 오늘 날짜 타이머 리스트 가져오기
	 */
	public List<TimerRedisDto> getListByTodayAndBookStatusIdIn(Long userId, List<Long> bookStatusIdList) {
		List<TimerRedisDto> resultList;

		if (todayFirstAccess(userId)) {
			resultList = createTimerRedisListByTodayFirstAccess(userId, bookStatusIdList);
		} else {
			List<String> redisIdList = bookStatusIdList.stream().map(e -> TimerRedisDto.toIdToday(userId, e)).collect(Collectors.toList());
			resultList = getListByIdIn(redisIdList);
		}

		return resultList;
	}

}
