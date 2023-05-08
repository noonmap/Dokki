package com.dokki.timer.repository;


import com.dokki.timer.entity.DailyStatisticsEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.time.LocalDate;
import java.util.List;


public interface DailyStatisticsRepository extends JpaRepository<DailyStatisticsEntity, Long> {
	DailyStatisticsEntity getByUserIdAndRecordDateIs(Long userId, LocalDate recordDate);


	List<DailyStatisticsEntity> getByUserIdAndRecordDateGreaterThanEqualAndRecordDateLessThan(Long userId, LocalDate startDate, LocalDate endDateNext);
}
