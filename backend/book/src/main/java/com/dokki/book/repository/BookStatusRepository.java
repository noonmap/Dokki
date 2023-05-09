package com.dokki.book.repository;


import com.dokki.book.entity.BookStatusEntity;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Slice;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;


@Repository
public interface BookStatusRepository extends JpaRepository<BookStatusEntity, Long> {

	@EntityGraph(attributePaths = { "bookId" }, type = EntityGraph.EntityGraphType.LOAD)
	Slice<BookStatusEntity> getByUserIdAndStatusEquals(Long userId, String status, Pageable pageable);

	void deleteByIdAndUserId(Long id, Long userId);

	BookStatusEntity findByUserIdAndBookId(Long userId, String bookId);

}
