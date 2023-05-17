package com.dokki.timer.redis;


import com.dokki.timer.redis.dto.TodayAccessRedisDto;
import org.springframework.data.repository.CrudRepository;


public interface TodayAccessRedisRepository extends CrudRepository<TodayAccessRedisDto, Long> {
}
