package com.dokki.timer.repository;

import com.dokki.timer.redis.TimerRedis;
import org.springframework.data.repository.CrudRepository;

public interface TimerRedisRepository extends CrudRepository<TimerRedis, Long> {
}
