package com.dokki.timer.service;


import com.dokki.timer.client.BookClient;
import com.dokki.timer.config.exception.CustomException;
import com.dokki.timer.entity.DailyStatisticsEntity;
import com.dokki.timer.entity.TimerEntity;
import com.dokki.timer.redis.TimerRedis;
import com.dokki.timer.redis.TimerRedisService;
import com.dokki.timer.repository.DailyStatisticsRepository;
import com.dokki.timer.repository.TimerRepository;
import com.dokki.util.book.dto.request.BookCompleteDirectRequestDto;
import com.dokki.util.common.error.ErrorCode;
import com.dokki.util.timer.dto.response.TimerSimpleResponseDto;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.Duration;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;


@Log4j2
@Service
@RequiredArgsConstructor
public class TimerService {

	private final TimerRepository timerRepository;
	private final DailyStatisticsRepository dailyStatisticsRepository;

	private final TimerRedisService timerRedisService;

	private final BookClient bookClient;


	/**
	 * 독서 시간 측정 시작
	 *
	 * @param bookStatusId
	 */
	public void startTimer(Long userId, Long bookStatusId) {
		timerRedisService.setTimerRedis(userId, bookStatusId);
	}


	/**
	 * 독서 시간 측정 종료
	 *
	 * @param bookStatusId
	 */
	@Transactional
	public void endTimer(Long bookStatusId, Long userId) {
		// 타이머 시작기록 가져온 후 redis에서 삭제
		TimerRedis getTimer = timerRedisService.getTimerRedis(userId);
		timerRedisService.deleteTimerRedis(userId);
		LocalDateTime startTime = getTimer.getStartAt();

		LocalDateTime endTime = LocalDateTime.now();
		Duration duration = Duration.between(startTime, endTime);
		Long currTime = duration.getSeconds();

		// bookStatusId로 타이머 가져오기, 존재하지 않다면 타이머 새로 만들기
		Optional<TimerEntity> optionalTimerEntity = timerRepository.findTopByBookStatusId(bookStatusId);
		if (optionalTimerEntity.isEmpty()) {
			// TODO: bookStatusId로 bookId 가져와서 추가하기
			String bookId = bookClient.getBookIdByBookStatusId(bookStatusId);
			timerRepository.save(TimerEntity.builder()
				.userId(userId)
				.bookId(bookId)
				.bookStatusId(bookStatusId)
				.accumTime(Math.toIntExact(currTime))      // toIntExact -> ArithmeticException (if the argument overflows an int)
				.startTime(startTime.toLocalDate())
				.endTime(endTime.toLocalDate())
				.build());
		} else {
			TimerEntity timerEntity = optionalTimerEntity.get();
			// 로그인한 유저의 타이머가 맞는지 확인
			if (!userId.equals(timerEntity.getUserId())) {
				throw new CustomException(ErrorCode.INVALID_REQUEST);
			}

			// 타이머 종료 및 누적시간 계산
			timerEntity.updateTimerStop(Math.toIntExact(currTime), endTime.toLocalDate());

			// 일일통계 계산 (오늘 통계 가져오기)
			DailyStatisticsEntity dailyStatisticsEntity = dailyStatisticsRepository.getByUserIdAndBookIdAndRecordDateIs(userId, timerEntity.getBookId(), LocalDate.now());
			if (dailyStatisticsEntity == null) {
				dailyStatisticsEntity = DailyStatisticsEntity.builder()
					.userId(userId)
					.bookId(timerEntity.getBookId())
					.accumTime(Math.toIntExact(currTime))
					.recordDate(LocalDate.now())
					.build();
			} else {
				dailyStatisticsEntity.updateTimerStop(Math.toIntExact(currTime));
			}
			dailyStatisticsRepository.save(dailyStatisticsEntity);
		}

	}


	/**
	 * 타이머 정보를 삭제합니다.
	 *
	 * @param bookStatusId
	 */
	public void deleteTimer(Long bookStatusId) {
		timerRepository.deleteByBookStatusId(bookStatusId);
	}


	/**
	 * 타이머 정보 중 누적 시간을 조회합니다.
	 * 조회하고 싶은 도서의 book_status_id를 리스트로 Request에 담아 요청합니다.
	 * 타이머 뷰에서 이용합니다.
	 *
	 * @param bookStatusIdList
	 * @return
	 */
	public List<TimerSimpleResponseDto> getAccumTimeList(List<Long> bookStatusIdList) {
		List<TimerEntity> timerList = timerRepository.findByBookStatusIdIn(bookStatusIdList);
		return timerList.stream().map(
			o -> TimerSimpleResponseDto.builder()
				.bookStatusId(o.getBookStatusId())
				.accumTime(o.getAccumTime())
				.build()
		).collect(Collectors.toList());
	}


	/**
	 * 독서 완독 시간 정보를 추가 또는 삭제(null)합니다.
	 *
	 * @param bookStatusId
	 */
	@Transactional
	public void modifyEndTime(Long userId, Long bookStatusId) {
		TimerEntity timerEntity = timerRepository.findTopByBookStatusId(bookStatusId).orElseThrow(() -> new CustomException(ErrorCode.INVALID_REQUEST));
		if (!userId.equals(timerEntity.getUserId())) {
			throw new CustomException(ErrorCode.INVALID_REQUEST);
		}
		timerEntity.updateBookComplete(LocalDate.now());
	}


	public void createTimerDirect(Long userId, BookCompleteDirectRequestDto request) {
		Optional<TimerEntity> optionalTimerEntity = timerRepository.findTopByBookStatusId(request.getBookStatusId());

		if (!optionalTimerEntity.isEmpty()) {// if timer already exist
			TimerEntity timerEntity = optionalTimerEntity.get();
			// 로그인한 유저의 타이머가 맞는지 확인
			if (!userId.equals(timerEntity.getUserId())) {
				throw new CustomException(ErrorCode.INVALID_REQUEST);
			}
			// 시작시간, 종료시간 수정 후 저장
			timerEntity.setStartTime(request.getStartTime());
			timerEntity.setEndTime(request.getEndTime());
			timerRepository.save(timerEntity);
		} else {
			timerRepository.save(TimerEntity.builder()
				.userId(userId)
				.bookId(request.getBookId())
				.bookStatusId(request.getBookStatusId())
				.accumTime(0)
				.startTime(request.getStartTime())
				.endTime(request.getEndTime())
				.build());
		}

	}

}