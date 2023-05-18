package com.dokki.timer.redis.repository;


import com.dokki.timer.redis.dto.RunTimerRedisDto;
import org.springframework.data.repository.CrudRepository;


public interface RunTimerRedisRepository extends CrudRepository<RunTimerRedisDto, Long> {
}
