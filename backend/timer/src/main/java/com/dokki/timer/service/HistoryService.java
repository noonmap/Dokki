package com.dokki.timer.service;


import com.dokki.timer.client.BookClient;
import com.dokki.timer.dto.response.DailyStatisticsResponseDto;
import com.dokki.timer.dto.response.MonthlyStatisticsResponseDto;
import com.dokki.timer.entity.DailyStatisticsEntity;
import com.dokki.timer.repository.DailyStatisticsRepository;
import com.dokki.util.book.dto.response.BookSimpleResponseDto;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import java.util.stream.IntStream;


@Slf4j
@Service
@RequiredArgsConstructor
public class HistoryService {

	private final DailyStatisticsRepository dailyStatisticsRepository;

	private final BookClient bookClient;


	/**
	 * 한 해 독서 시간 조회 (프로필에서 사용)
	 *
	 * @param userId
	 * @param year
	 * @return 한 해 독서시간 (월별 통계 리스트)
	 */
	public List<MonthlyStatisticsResponseDto> getYearHistory(Long userId, int year) {
		List<MonthlyStatisticsResponseDto> monthlyStatisticsList = new ArrayList<>();

		// 통계기록 가져오기
		List<Map<Integer, Integer>> monthlyStatisticsMapList = dailyStatisticsRepository.getMonthlyStatisticsListByYear(userId, year);
		Map<Integer, Integer> map = new HashMap<>();
		for (Map<Integer, Integer> m : monthlyStatisticsMapList) {
			map.putAll(m);
		}

		// 리스트에 통계기록 추가
		IntStream.range(1, 13).forEach(i -> {
				int timeCount = map.getOrDefault(i, 0);
				if (timeCount != 0) timeCount = timeCount / (60 * 60);
				monthlyStatisticsList.add(
					MonthlyStatisticsResponseDto.builder()
						.month(i)
						.count(timeCount)
						.build());
			}
		);
		return monthlyStatisticsList;
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
		LocalDate startDate = LocalDate.of(year, month, 1);
		LocalDate endDate = LocalDate.of(year, month + 1, 1);
		List<DailyStatisticsEntity> dailyStatisticsEntityList = dailyStatisticsRepository.getDailyStatisticsList(userId, startDate, endDate);

		// dailyStatisticsEntityList에서 bookId 리스트 만들어서 책 정보 요청
		List<String> bookIdList = dailyStatisticsEntityList.stream()
			.map(DailyStatisticsEntity::getBookId)
			.collect(Collectors.toList());
		List<BookSimpleResponseDto> bookList = bookClient.getBookSimple(bookIdList);

		return DailyStatisticsResponseDto.fromEntityList(dailyStatisticsEntityList, bookList);
	}

}
