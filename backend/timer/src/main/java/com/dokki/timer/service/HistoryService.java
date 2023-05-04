package com.dokki.timer.service;


import com.dokki.timer.dto.response.DailyStatisticsResponseDto;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.List;


@Slf4j
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
		System.out.println(userId);
		System.out.println(year);
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
	public List<DailyStatisticsResponseDto> getDailyStatisticsList(Long userId, int year, int month) {
		/* TODO:
		 *  1. timer 서버와 통신
		 *  2. 책 표지정보 추가해서 리턴
		 *  */
		return null;
	}

}
