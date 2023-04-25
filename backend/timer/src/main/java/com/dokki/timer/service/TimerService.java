package com.dokki.timer.service;


import com.dokki.timer.dto.response.TimerSimpleResponseDto;
import com.dokki.timer.repository.DailyStatisticsRepository;
import com.dokki.timer.repository.TimerRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;


@Log4j2
@Service
@RequiredArgsConstructor
public class TimerService {

	private final TimerRepository timerRepository;
	private final DailyStatisticsRepository dailyStatisticsRepository;


	/**
	 * 독서 시간 측정 시작
	 *
	 * @param bookId
	 */
	public void startTimer(String bookId) {
	}


	/**
	 * 독서 시간 측정 종료
	 *
	 * @param bookId
	 */
	public void endTimer(String bookId) {
	}


	/**
	 * 한 달 독서 기록을 조회합니다. (프로필에서 사용, 달력 형태)
	 * 하루 중 가장 읽은 시간이 긴 책 리스트를 반환합니다.
	 * 리스트 요소의 형태는 {day: Integer, bookId: String}와 같습니다.
	 *
	 * @param userId
	 * @param year
	 * @param month
	 * @return
	 */
	public List<Map<String, String>> getMonthlyReadTimeHistory(Long userId, Integer year, Integer month) {
		return new ArrayList<>();
	}


	/**
	 * 타이머 정보를 삭제합니다.
	 *
	 * @param userId
	 * @param bookId
	 */
	public void deleteTimer(Integer userId, String bookId) {
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
		return new ArrayList<>();
	}


	/**
	 * 독서 완독 시간 정보를 추가 또는 삭제(null)합니다.
	 *
	 * @param bookStatusId
	 * @param done
	 */
	public void modifyEndTime(Long bookStatusId, Boolean done) {
	}

}
