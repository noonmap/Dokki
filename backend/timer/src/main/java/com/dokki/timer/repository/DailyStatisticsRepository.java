package com.dokki.timer.repository;


import com.dokki.timer.entity.DailyStatisticsEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.time.LocalDate;
import java.util.List;


public interface DailyStatisticsRepository extends JpaRepository<DailyStatisticsEntity, Long> {

	DailyStatisticsEntity getByUserIdAndRecordDateIs(Long userId, LocalDate recordDate);

	List<DailyStatisticsEntity> getByUserIdAndRecordDateGreaterThanEqualAndRecordDateLessThan(Long userId, LocalDate startDate, LocalDate endDateNext);

	/**
	 * 한달 독서기록에서 사용하는 메소드
	 * 유저별 하루 독서기록 중 가장 읽은 시간이 긴 기록 리스트 리턴
	 */
	@Query(value = "select d1 from DailyStatisticsEntity d1 "
		+ " where (d1.accumTime, d1.recordDate, d1.userId) "
		+ " in ( "
		+ " select max(d2.accumTime), d2.recordDate, d2.userId from DailyStatisticsEntity d2 "
		+ " where d2.userId = :userId "
		+ " and d2.recordDate >= :startDate "
		+ " and d2.recordDate < :endDate "
		+ " group by d2.recordDate"
		+ ") group by d1.recordDate "
	)
	List<DailyStatisticsEntity> getDailyStatisticsList(@Param("userId") Long userId, @Param("startDate") LocalDate startDate, @Param("endDate") LocalDate endDateNext);

}
