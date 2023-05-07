package com.dokki.timer.repository;


import com.dokki.timer.entity.DailyStatisticsEntity;
import org.springframework.data.jpa.repository.JpaRepository;

import java.time.LocalDate;


public interface DailyStatisticsRepository extends JpaRepository<DailyStatisticsEntity, Long> {
	DailyStatisticsEntity getByUserIdAndRecordDateIs(Long userId, LocalDate recordDate);
}
