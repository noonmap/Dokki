package com.dokki.review.repository;


import com.dokki.review.redis.DiaryImageRedis;
import org.springframework.data.repository.CrudRepository;


public interface DiaryImageRedisRepository extends CrudRepository<DiaryImageRedis, Long> {
}
