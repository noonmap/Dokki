package com.dokki.timer.service;


import com.dokki.timer.client.BookClient;
import com.dokki.timer.config.exception.CustomException;
import com.dokki.timer.entity.TimerEntity;
import com.dokki.timer.redis.RunTimerRedisDto;
import com.dokki.timer.redis.RunTimerRedisService;
import com.dokki.timer.redis.TimerRedisDto;
import com.dokki.timer.redis.TimerRedisService;
import com.dokki.timer.repository.TimerRepository;
import com.dokki.util.book.dto.request.BookCompleteDirectRequestDto;
import com.dokki.util.common.error.ErrorCode;
import com.dokki.util.timer.dto.response.TimerResponseDto;
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

	private final RunTimerRedisService runTimerRedisService;
	private final TimerRedisService timerRedisService;

	private final BookClient bookClient;


	/**
	 * 타이머 정보 가져오기
	 *
	 * @param bookStatusId
	 */
	public TimerResponseDto getTimerByBookStatusId(Long userId, Long bookStatusId) {
		Optional<TimerEntity> optionalTimerEntity = timerRepository.findTopByBookStatusId(bookStatusId);
		TimerResponseDto response;

		if (optionalTimerEntity.isEmpty()) {
			throw new CustomException(ErrorCode.NOTFOUND_RESOURCE);
		} else {
			TimerEntity timerEntity = optionalTimerEntity.get();
			// 로그인한 유저의 타이머가 맞는지 확인
			if (!userId.equals(timerEntity.getUserId())) {
				throw new CustomException(ErrorCode.INVALID_REQUEST);
			}

			// 레디스에 오늘자 타이머 정보 있을 경우 누적시간 수정
			try {
				TimerRedisDto timerRedisDto = timerRedisService.getTimerRedis(TimerRedisDto.toIdToday(userId, bookStatusId));
				timerEntity.updateTimerStop(timerRedisDto.getAccumTimeToday(), timerRedisDto.getEndTime());
			} catch (Exception e) {
				// do nothing
			}

			response = TimerResponseDto.builder()
				.id(timerEntity.getId())
				.bookStatusId(timerEntity.getBookStatusId())
				.userId(timerEntity.getUserId())
				.bookId(timerEntity.getBookId())
				.accumTime(timerEntity.getAccumTime())
				.startTime(timerEntity.getStartTime())
				.endTime(timerEntity.getEndTime())
				.build();
		}
		return response;
	}


	/**
	 * 독서 시간 측정 시작
	 *
	 * @param bookStatusId
	 */
	public void startTimer(Long userId, Long bookStatusId) {
		RunTimerRedisDto runTimer = runTimerRedisService.setRunTimerRedis(userId, bookStatusId);
		try {
			timerRedisService.getTimerRedisByTodayAndBookStatusId(userId, bookStatusId);
		} catch (CustomException e) {   // 기존에 존재하지 않는 타이머일 경우 db에 타이머 추가
			String bookId = bookClient.getBookIdByBookStatusId(bookStatusId);
			TimerEntity timerEntity = timerRepository.save(TimerEntity.builder()
				.userId(userId)
				.bookId(bookId)
				.bookStatusId(bookStatusId)
				.accumTime(0)
				.startTime(runTimer.getStartAt().toLocalDate())
				.endTime(runTimer.getStartAt().toLocalDate())
				.build());

			// 추가된 타이머 레디스에 저장
			TimerRedisDto timerRedisDto = timerRedisService.createOrModifyTimerRedis(timerEntity);
			log.info("timer service - create {}", timerRedisDto);
		}
	}


	/**
	 * 독서 시간 측정 종료
	 *
	 * @param bookStatusId
	 */
	@Transactional
	public void endTimer(Long bookStatusId, Long userId) {
		LocalDateTime endTime = LocalDateTime.now();

		// 타이머 시작기록 가져온 후 redis에서 삭제
		RunTimerRedisDto getRunTimer = runTimerRedisService.getRunTimerRedis(userId);
		runTimerRedisService.deleteRunTimerRedis(userId);
		LocalDateTime startTime = getRunTimer.getStartAt();

		Duration duration = Duration.between(startTime, endTime);
		long currTime = duration.getSeconds();
		TimerRedisDto timerRedisDto = timerRedisService.getTimerRedisByTodayAndBookStatusId(userId, bookStatusId);

		timerRedisDto.updateTimerStop(Math.toIntExact(currTime), startTime.toLocalDate());  // toIntExact -> ArithmeticException (if the argument overflows an int)
		timerRedisDto = timerRedisService.createOrModifyTimerRedis(timerRedisDto);
	}


	/**
	 * 타이머 정보를 삭제합니다.
	 *
	 * @param bookStatusId
	 */
	public void deleteTimer(Long userId, Long bookStatusId) {
		timerRepository.deleteByBookStatusId(bookStatusId);
		timerRedisService.deleteTimerRedis(TimerRedisDto.toIdToday(userId, bookStatusId));
		log.info("timer service - delete timer (bookStatusId - {})", bookStatusId);
	}


	/**
	 * 타이머 정보 중 누적 시간을 조회합니다.
	 * 조회하고 싶은 도서의 book_status_id를 리스트로 Request에 담아 요청합니다.
	 * 타이머 뷰에서 이용합니다.
	 *
	 * @param bookStatusIdList
	 * @return
	 */
	public List<TimerSimpleResponseDto> getAccumTimeList(Long userId, List<Long> bookStatusIdList) {
		List<TimerRedisDto> timerList = timerRedisService.getListByTodayAndBookStatusIdIn(userId, bookStatusIdList);
		return timerList.stream().map(
			o -> TimerSimpleResponseDto.builder()
				.bookStatusId(o.getBookStatusIdFromId())
				.accumTime(o.getAccumTimeBefore() + o.getAccumTimeToday())
				.build()
		).collect(Collectors.toList());
	}


	/**
	 * 독서 완독 시간 정보를 수정합니다.
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
		timerRedisService.createOrModifyTimerRedis(timerEntity);
	}


	public void createTimerDirect(Long userId, BookCompleteDirectRequestDto request) {
		Optional<TimerEntity> optionalTimerEntity = timerRepository.findTopByBookStatusId(request.getBookStatusId());

		if (optionalTimerEntity.isPresent()) {// if timer already exist
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


	public void resetAccumTime(Long userId, Long bookStatusId) {
		timerRepository.resetAccumTimeByUserIdAndBookStatusId(userId, bookStatusId);
	}

}