package com.dokki.timer.repository;


import com.dokki.timer.dto.response.MonthlyStatisticsResponseDto;
import com.dokki.timer.entity.DailyStatisticsEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.time.LocalDate;
import java.util.List;


public interface DailyStatisticsRepository extends JpaRepository<DailyStatisticsEntity, Long> {

	DailyStatisticsEntity getByUserIdAndBookIdAndRecordDateIs(Long userId, String bookId, LocalDate recordDate);

	@Query(value = "select new com.dokki.timer.dto.response.MonthlyStatisticsResponseDto( month(d.recordDate), sum(d.accumTime) ) from DailyStatisticsEntity d"
		+ " where d.userId = :userId "
		+ " and year(d.recordDate) = :year "
		+ " group by month(d.recordDate)")
	List<MonthlyStatisticsResponseDto> getMonthlyStatisticsListByYear(@Param("userId") Long userId, @Param("year") int year);

	/**
	 * 한달 독서기록에서 사용하는 메소드
	 * 유저별 하루 독서기록 중 가장 읽은 시간이 긴 기록 리스트 리턴
	 */
	@Query(value = "select d1 from DailyStatisticsEntity d1 "
		+ " where d1.userId = :userId "
		+ " and (d1.accumTime, d1.recordDate) "
		+ " in ( "
		+ " select max(d2.accumTime), d2.recordDate from DailyStatisticsEntity d2 "
		+ " where d2.userId = :userId "
		+ " and d2.recordDate >= :startDate "
		+ " and d2.recordDate < :endDate "
		+ " group by d2.recordDate"
		+ ")"
	)
	List<DailyStatisticsEntity> getDailyStatisticsList(@Param("userId") Long userId, @Param("startDate") LocalDate startDate, @Param("endDate") LocalDate endDateNext);

	@Query("select sum(d.accumTime) from DailyStatisticsEntity d where d.userId = :userId and d.recordDate = current_date")
	Long getTodayReadTime(@Param("userId") Long userId);

}
