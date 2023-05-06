package com.dokki.timer.service;


import com.dokki.timer.config.exception.CustomException;
import com.dokki.timer.entity.TimerEntity;
import com.dokki.timer.repository.DailyStatisticsRepository;
import com.dokki.timer.repository.TimerRepository;
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


	/**
	 * 독서 시간 측정 시작
	 *
	 * @param bookStatusId
	 */
	public void startTimer(Long bookStatusId) {
	}


	/**
	 * 독서 시간 측정 종료
	 *
	 * @param bookStatusId
	 */
	@Transactional
	public void endTimer(Long bookStatusId, Long userId) {
		// TODO: 레디스에서 가져온 데이터로 시간 계산
		LocalDateTime startTime = null;
		// 임시
		startTime = LocalDateTime.now().minusMinutes(20);

		LocalDateTime endTime = LocalDateTime.now();
		Duration duration = Duration.between(startTime, endTime);
		Long currTime = duration.getSeconds();

		// bookStatusId로 타이머 가져오기, 존재하지 않다면 타이머 새로 만들기
		Optional<TimerEntity> optionalTimerEntity = timerRepository.findTopByBookStatusId(bookStatusId);
		if (optionalTimerEntity.isEmpty()) {
			// TODO: bookStatusId로 bookId 가져와서 추가하기
			timerRepository.save(TimerEntity.builder()
				.userId(userId)
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
		}

	}


	/**
	 * 타이머 정보를 삭제합니다.
	 *
	 * @param userId
	 * @param bookStatusId
	 */
	public void deleteTimer(Long bookStatusId, Long userId) {
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

}
