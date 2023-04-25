package com.dokki.timer.repository;


import com.dokki.timer.entity.DailyStatisticsEntity;
import org.springframework.data.jpa.repository.JpaRepository;


public interface DailyStatisticsRepository extends JpaRepository<DailyStatisticsEntity, Long> {
}
