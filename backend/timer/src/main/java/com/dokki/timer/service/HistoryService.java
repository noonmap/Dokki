package com.dokki.timer.service;


import com.dokki.timer.client.BookClient;
import com.dokki.timer.dto.response.DailyStatisticsResponseDto;
import com.dokki.timer.entity.DailyStatisticsEntity;
import com.dokki.timer.repository.DailyStatisticsRepository;
import com.dokki.util.book.dto.response.BookSimpleResponseDto;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.List;
import java.util.stream.Collectors;


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
	 * @return int[12] 한 해 독서시간
	 */
	public int[] getYearHistory(Long userId, int year) {
		int[] result = new int[12];
		LocalDate startDate = LocalDate.of(year, 1, 1);
		LocalDate endDate = LocalDate.of(year + 1, 1, 1);
		List<DailyStatisticsEntity> dailyStatisticsEntityList = dailyStatisticsRepository.getByUserIdAndRecordDateGreaterThanEqualAndRecordDateLessThan(userId, startDate, endDate);
		for (DailyStatisticsEntity e : dailyStatisticsEntityList) {
			int month = e.getRecordDate().getMonth().getValue();
			result[month] += e.getAccumTime();
		}
		for (int i = 0; i < 12; i++) {
			result[i] = (int) Math.ceil((double) result[i] / (60 * 60));   // 시간으로 계산
		}
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
