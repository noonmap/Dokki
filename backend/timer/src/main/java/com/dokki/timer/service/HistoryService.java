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
import java.util.Arrays;
import java.util.Comparator;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.function.Function;
import java.util.function.Predicate;
import java.util.stream.Collectors;


@Slf4j
@Service
@RequiredArgsConstructor
public class HistoryService {

	private final DailyStatisticsRepository dailyStatisticsRepository;

	private final BookClient bookClient;


	public static <T> Predicate<T> distinctByKeys(Function<? super T, ?>... keyExtractors) {
		final Map<List<?>, Boolean> seen = new ConcurrentHashMap<>();

		return t -> {
			final List<?> keys = Arrays.stream(keyExtractors).map(ke -> ke.apply(t)).collect(Collectors.toList());

			return seen.putIfAbsent(keys, Boolean.TRUE) == null;
		};
	}


	/**
	 * 한 해 독서 시간 조회 (프로필에서 사용)
	 *
	 * @param userId
	 * @param year
	 * @return 한 해 독서시간 (월별 통계 리스트)
	 */
	public List<MonthlyStatisticsResponseDto> getYearHistory(Long userId, int year) {
		// 통계기록 가져오기
		List<MonthlyStatisticsResponseDto> monthlyStatisticsList = dailyStatisticsRepository.getMonthlyStatisticsListByYear(userId, year);
		monthlyStatisticsList.forEach(o -> o.setCount(o.getCount() / (60 * 60)));
		// 리스트에 통계기록 추가
		for (int i = 1; i <= 12; i++) {
			int finalI = i;
			boolean isExist = monthlyStatisticsList.stream()
				.anyMatch(monthlyStatistics -> monthlyStatistics.getMonth() == finalI);

			if (!isExist)
				monthlyStatisticsList.add(
					new MonthlyStatisticsResponseDto(i, 0L)
				);
		}
		monthlyStatisticsList.sort(Comparator.comparingInt(MonthlyStatisticsResponseDto::getMonth));
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

		List<DailyStatisticsEntity> removeDuplicateList = dailyStatisticsEntityList.stream().filter(distinctByKeys(DailyStatisticsEntity::getRecordDate, DailyStatisticsEntity::getAccumTime))
			.collect(Collectors.toList());

		// dailyStatisticsEntityList에서 bookId 리스트 만들어서 책 정보 요청
		List<String> bookIdList = removeDuplicateList.stream()
			.map(DailyStatisticsEntity::getBookId)
			.collect(Collectors.toList());
		List<BookSimpleResponseDto> bookList = bookClient.getBookSimple(bookIdList);

		return DailyStatisticsResponseDto.fromEntityList(removeDuplicateList, bookList);
	}


	public Long getTodayReadTime(Long userId) {
		return dailyStatisticsRepository.getTodayReadTime(userId);
	}

}
