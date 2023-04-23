package com.dokki.book.service;


import com.dokki.book.dto.response.DailyStatisticsResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import org.springframework.stereotype.Service;

import java.util.List;


@Log4j2
@Service
@RequiredArgsConstructor
public class HistoryService {

	/**
	 * 한 해 독서 시간 조회 (프로필에서 사용)
	 *
	 * @param userId
	 * @param year
	 * @return Integer[12] 한 해 독서시간
	 */
	public Integer[] getYearHistory(Long userId, int year) {
		Integer[] result = new Integer[12];
		return result;
	}


	/**
	 * 한 달 독서 기록 조회 (일별 독서기록 리스트, 프로필에서 사용, 달력 형태)
	 *
	 * @param userId
	 * @param year
	 * @param month
	 * @return DailyStatisticsResponse
	 */
	public List<DailyStatisticsResponse> getDailyStatisticsList(Long userId, int year, int month) {
		/* TODO:
		 *  1. timer 서버와 통신
		 *  2. 책 표지정보 추가해서 리턴
		 *  */
		return null;
	}

}
