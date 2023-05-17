package com.dokki.review.redis;


import com.dokki.review.repository.DiaryImageRedisRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.Optional;


@Log4j2
@Service
@RequiredArgsConstructor

public class DiaryImageRedisService {

	private final DiaryImageRedisRepository diaryImageRedisRepository;


	public void setDiaryImageRedis(Long userId) {
		deleteDiaryImageRedis(userId);
		diaryImageRedisRepository.save(DiaryImageRedis.builder()
			.userId(userId)
			.requestCount(0)
			.requestDate(LocalDate.now())
			.build());
	}


	public void setDiaryImageRedis(Long userId, Integer requestCount) {
		deleteDiaryImageRedis(userId);
		diaryImageRedisRepository.save(DiaryImageRedis.builder()
			.userId(userId)
			.requestCount(requestCount)
			.requestDate(LocalDate.now())
			.build());
	}


	public Optional<DiaryImageRedis> getDiaryImageRedis(Long userId) {
		return diaryImageRedisRepository.findById(userId);
	}


	public void deleteDiaryImageRedis(Long userId) {
		diaryImageRedisRepository.deleteById(userId);
	}

}
