package com.dokki.timer.service;


import com.dokki.timer.dto.response.DailyStatisticsResponseDto;
import com.dokki.timer.entity.DailyStatisticsEntity;
import com.dokki.timer.repository.DailyStatisticsRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.Arrays;
import java.util.List;


@Slf4j
@Service
@RequiredArgsConstructor
public class HistoryService {
	private final DailyStatisticsRepository dailyStatisticsRepository;

	/**
	 * 한 해 독서 시간 조회 (프로필에서 사용)
	 *
	 * @param userId
	 * @param year
	 * @return int[12] 한 해 독서시간
	 */
	public int[] getYearHistory(Long userId, int year) {
		int[] result = new int[12];
		LocalDate startDate = LocalDate.of(year,1,1);
		LocalDate endDate = LocalDate.of(year+1, 1,1);
		List<DailyStatisticsEntity> dailyStatisticsEntityList = dailyStatisticsRepository.getByUserIdAndRecordDateGreaterThanEqualAndRecordDateLessThan(userId, startDate, endDate);
		for(DailyStatisticsEntity e : dailyStatisticsEntityList){
			int month = e.getRecordDate().getMonth().getValue();
			result[month] += e.getAccumTime();
		}
		for(int i = 0; i < 12; i++){
			result[i] = (int) Math.ceil((double)result[i]/(60*60));   // 시간으로 계산
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
		/* TODO: 책 표지정보 추가해서 리턴
		 *  */
		LocalDate startDate = LocalDate.of(year,month,1);
		LocalDate endDate = LocalDate.of(year, month+1,1);
		List<DailyStatisticsEntity> dailyStatisticsEntityList = dailyStatisticsRepository.getByUserIdAndRecordDateGreaterThanEqualAndRecordDateLessThan(userId, startDate, endDate);

		return null;
	}

}
