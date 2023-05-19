package com.dokki.review.repository;


import com.dokki.review.entity.CommentEntity;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Slice;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Optional;


public interface CommentRepository extends JpaRepository<CommentEntity, Long> {

	Slice<CommentEntity> findByBookIdOrderByCreatedAtDesc(String bookId, Pageable pageable);

	List<CommentEntity> findTop3ByBookIdOrderByCreatedAtDesc(String bookId);

	boolean existsById(Long commentId);

	void deleteById(Long commentId);

	@Query("select avg(c.score) from CommentEntity c where c.bookId = :bookId")
	Optional<Float> findAvgScoreByBookId(@Param(value = "bookId") String bookId);

}