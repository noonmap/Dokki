package com.dokki.book.service;


import com.dokki.book.client.TimerClient;
import com.dokki.book.config.exception.CustomException;
import com.dokki.book.dto.response.BookTimerResponseDto;
import com.dokki.book.entity.BookStatusEntity;
import com.dokki.book.repository.BookStatusRepository;
import com.dokki.util.common.error.ErrorCode;
import com.dokki.util.timer.dto.response.TimerSimpleResponseDto;
import feign.FeignException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Slice;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Objects;
import java.util.stream.Collectors;


@Slf4j
@Service
@RequiredArgsConstructor
public class BookTimerService {

	private final String STATUS_IN_PROGRESS = "T";
	private final String STATUS_DONE = "F";

	private final BookStatusRepository bookStatusRepository;

	private final TimerClient timerClient;


	/**
	 * [타이머 뷰] 읽고 있는 도서 목록 조회
	 *
	 * @param pageable
	 * @return 읽고있는 도서 목록
	 */

	public Slice<BookTimerResponseDto> getBookTimerList(Long userId, Pageable pageable) {
		Slice<BookTimerResponseDto> resultList;
		Slice<BookStatusEntity> bookTimerSlice = bookStatusRepository.getByUserIdAndStatusEquals(userId, STATUS_IN_PROGRESS, pageable);

		// bookTimerSlice에서 statusId 리스트 추출
		List<Long> statusIdList = bookTimerSlice.getContent().stream()
			.map(BookStatusEntity::getId)
			.collect(Collectors.toList());

		try {
			// timer 서버에서 각 statusId마다 time 가져오기
			List<TimerSimpleResponseDto> timeList = timerClient.getAccumTime(statusIdList);
			resultList = BookTimerResponseDto.fromStatusEntityAndTimeListSlice(bookTimerSlice, timeList);
		} catch (FeignException e) {
			log.error(e.getMessage());

			// timer 정보 없을 경우 time 이 default값인 변환메소드 호출
			resultList = BookTimerResponseDto.fromEntitySlice(bookTimerSlice);
		}
		return resultList;
	}


	/**
	 * [타이머 뷰] 읽고 있는 도서 삭제
	 *
	 * @param bookStatusId
	 * @param userId       유저 id
	 */
	public void deleteBookTimer(Long bookStatusId, Long userId) {
		BookStatusEntity statusEntity = bookStatusRepository.findById(bookStatusId).orElseThrow(() -> new CustomException(ErrorCode.NOTFOUND_RESOURCE));

		// 로그인한 유저의 책이 맞는지 확인
		if (!Objects.equals(statusEntity.getUserId(), userId)) {
			throw new CustomException(ErrorCode.INVALID_REQUEST);
		}
		bookStatusRepository.deleteById(bookStatusId);

		try {
			timerClient.deleteTimer(bookStatusId);
		} catch (Exception e) {
			log.info("BookTimerService - 타이머 테이블 x, bookStatusId:{}", bookStatusId);
		}
	}

}
