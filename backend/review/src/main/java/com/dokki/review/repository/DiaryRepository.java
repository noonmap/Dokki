package com.dokki.review.repository;


import com.dokki.review.entity.DiaryEntity;
import org.springframework.data.jpa.repository.JpaRepository;


public interface DiaryRepository extends JpaRepository<DiaryEntity, Long> {
}
