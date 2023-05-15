package com.dokki.timer.repository;


import com.dokki.timer.redis.RunTimerRedisDto;
import org.springframework.data.repository.CrudRepository;


public interface RunTimerRedisRepository extends CrudRepository<RunTimerRedisDto, Long> {
}
