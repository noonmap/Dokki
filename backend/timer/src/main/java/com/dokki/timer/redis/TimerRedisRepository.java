package com.dokki.timer.redis;


import org.springframework.data.repository.CrudRepository;


public interface TimerRedisRepository extends CrudRepository<TimerRedisDto, String> {
}
