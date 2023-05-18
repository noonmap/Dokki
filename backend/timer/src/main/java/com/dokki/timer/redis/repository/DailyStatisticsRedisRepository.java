package com.dokki.timer.redis.repository;


import com.dokki.timer.redis.dto.DailyStatisticsRedisDto;
import org.springframework.data.repository.CrudRepository;


public interface DailyStatisticsRedisRepository extends CrudRepository<DailyStatisticsRedisDto, String> {
}
