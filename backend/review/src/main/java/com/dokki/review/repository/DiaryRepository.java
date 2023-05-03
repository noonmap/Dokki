package com.dokki.review.repository;


import com.dokki.review.entity.DiaryEntity;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Slice;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;


public interface DiaryRepository extends JpaRepository<DiaryEntity, Long> {

	Optional<DiaryEntity> findByUserIdAndBookId(Long userId, String bookId);

	Slice<DiaryEntity> findByUserIdOrderByCreatedAtDesc(Long userId, Pageable pageable);

	boolean existsByBookId(String bookId);

}
