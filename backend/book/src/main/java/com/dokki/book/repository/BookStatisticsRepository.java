package com.dokki.book.repository;


import com.dokki.book.entity.BookStatisticsEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;


@Repository
public interface BookStatisticsRepository extends JpaRepository<BookStatisticsEntity, Long> {

	@Transactional
	@Modifying
	@Query(value = "update dokki.book_statistics set mean_score = :reviewScore where book_id = :bookId", nativeQuery = true)
	void updateMeanScore(@Param("bookId") String bookId, @Param("reviewScore") Float reviewScore);

}
