package com.dokki.timer.repository;


import com.dokki.timer.redis.TimerRedisDto;
import org.springframework.data.repository.CrudRepository;


public interface TimerRedisRepository extends CrudRepository<TimerRedisDto, String> {
}
