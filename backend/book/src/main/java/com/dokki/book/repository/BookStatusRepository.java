package com.dokki.book.repository;


import com.dokki.book.entity.BookEntity;
import com.dokki.book.entity.BookStatusEntity;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Slice;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;


@Repository
public interface BookStatusRepository extends JpaRepository<BookStatusEntity, Long> {

	@EntityGraph(attributePaths = { "bookId" }, type = EntityGraph.EntityGraphType.LOAD)
	Slice<BookStatusEntity> getByUserIdAndStatusEquals(Long userId, String status, Pageable pageable);

	void deleteByIdAndUserId(Long id, Long userId);

	BookStatusEntity findTopByUserIdAndBookId(Long userId, BookEntity bookId);

	@Query(value = "select b.id from BookStatusEntity b where b.bookId = :bookId and b.status = :status")
	List<Long> findByBookIdAndStatusEqualsList(BookEntity bookId, String status);

}
