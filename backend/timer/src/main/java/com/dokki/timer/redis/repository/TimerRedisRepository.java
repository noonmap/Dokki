package com.dokki.timer.redis.repository;


import com.dokki.timer.redis.dto.TimerRedisDto;
import org.springframework.data.repository.CrudRepository;


public interface TimerRedisRepository extends CrudRepository<TimerRedisDto, String> {
}
