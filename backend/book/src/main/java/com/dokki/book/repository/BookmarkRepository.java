package com.dokki.book.repository;


import com.dokki.book.entity.BookEntity;
import com.dokki.book.entity.BookMarkEntity;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Slice;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;


@Repository
public interface BookmarkRepository extends JpaRepository<BookMarkEntity, Long> {

	Slice<BookMarkEntity> findSliceByUserId(Long userId, Pageable pageable);
	Boolean existsByUserIdAndBookId(Long userId, BookEntity bookEntity);
	void deleteByUserIdAndBookId(Long userId, BookEntity bookEntity);

}
