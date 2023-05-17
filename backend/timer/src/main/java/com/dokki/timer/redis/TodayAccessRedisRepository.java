package com.dokki.timer.redis;


import org.springframework.data.repository.CrudRepository;


public interface TodayAccessRedisRepository extends CrudRepository<TodayAccessRedisDto, Long> {
}
