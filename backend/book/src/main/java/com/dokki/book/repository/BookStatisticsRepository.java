package com.dokki.book.repository;


import com.dokki.book.entity.BookEntity;
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
	int updateMeanScore(@Param("bookId") String bookId, @Param("reviewScore") Float reviewScore);

	@Transactional
	@Modifying
	@Query(value = "update dokki.book_statistics "
		+ " set bookmarked_users = (select count(*) from bookmark where book_id = :bookId) "
		+ " where book_id = :bookId", nativeQuery = true)
	int updateBookMarkedUser(@Param("bookId") String bookId);

	@Transactional
	@Modifying
	@Query(value = "update dokki.book_statistics "
		+ " set completed_users = (select count(*) from book_status where book_id = :bookId and status = \"F\"), "
		+ " reading_users = (select count(*) from book_status where book_id = :bookId and status = \"T\") "
		+ " where b.bookId = :bookId", nativeQuery = true)
	int updateReadCompleteUser(@Param("bookId") BookEntity bookId);

	@Transactional
	@Modifying
	@Query(value = "update dokki.book_statistics "
		+ "set mean_read_time = "
		+ "(((mean_read_time * completed_users) + :accumTime) / (completed_users + 1))"
		+ ", completed_users = completed_users + 1,"
		+ " reading_users = reading_users - 1"
		+ " where book_id = :bookId",
		nativeQuery = true)
	void updateReadDataReadToComplete(@Param("bookId") String bookId, @Param("accumTime") Integer accumTime);

	@Transactional
	@Modifying
	@Query(value = "update dokki.book_statistics "
		+ "set mean_read_time = "
		+ "ifnull(((mean_read_time * completed_users) - :accumTime) / (completed_users - 1), 0), "
		+ " completed_users = completed_users - 1,"
		+ " reading_users = reading_users + 1"
		+ " where book_id = :bookId",
		nativeQuery = true)
	void updateReadDataCompleteToRead(@Param("bookId") String bookId, @Param("accumTime") Integer accumTime);

	@Transactional
	@Modifying
	@Query(value = "update dokki.book_statistics "
		+ "set mean_read_time = "
		+ "ifnull((mean_read_time * completed_users) - :accumTime) / (completed_users - 1), 0)"
		+ ", completed_users = completed_users - 1 "
		+ " where book_id = :bookId",
		nativeQuery = true)
	void updateReadDatasDeleteComplete(@Param("bookId") String bookId, @Param("accumTime") Integer accumTime);

}
