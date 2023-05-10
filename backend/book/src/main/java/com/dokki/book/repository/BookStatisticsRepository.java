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
	@Query(value = "update dokki.book_statistics set reading_users = reading_users + 1 where book_id = :bookId", nativeQuery = true)
	int updateAddOneReadingUser(@Param("bookId") String bookId);

	@Transactional
	@Modifying
	@Query(value = "update dokki.book_statistics set complete_users = complete_users + 1 where book_id = :bookId", nativeQuery = true)
	int updateAddOneCompleteUser(@Param("bookId") String bookId);

	@Transactional
	@Modifying
	@Query(value = "update dokki.book_statistics set bookmarked_users = bookmarked_users + 1 where book_id = :bookId", nativeQuery = true)
	int updateAddOneBookMarkedUser(@Param("bookId") String bookId);

	@Transactional
	@Modifying
	@Query(value = "update dokki.book_statistics set bookmarked_users = bookmarked_users - 1 where book_id = :bookId", nativeQuery = true)
	int updateDeleteOneBookMarkedUser(@Param("bookId") String bookId);

	@Transactional
	@Modifying
	@Query("update BookStatisticsEntity b set b.meanReadTime = :meanReadTime,"
		+ " b.completedUsers = b.completedUsers + :complete, "
		+ " b.readingUsers = b.readingUsers - :complete "
		+ " where b.bookId = :bookId")
	int updateReadDatas(@Param("bookId") BookEntity bookId, @Param("meanReadTime") int meanReadTime, @Param("complete") int complete);

	@Transactional
	@Modifying
	@Query(value = "update dokki.book_statistics "
		+ "set mean_read_time = "
		+ "(((mean_read_time * completed_users) + :accumTime) / (completed_users + 1))"
		+ ", completed_users = completed_users + 1,"
		+ " reading_users = reading_users - 1"
		+ " where book_id = :bookId",
		nativeQuery = true)
	void updateReadDatasComplete(String bookId, Integer accumTime);

	@Transactional
	@Modifying
	@Query(value = "update dokki.book_statistics "
		+ "set mean_read_time = "
		+ "ifnull((mean_read_time * completed_users) - :accumTime) / (completed_users - 1), 0)"
		+ ", completed_users = completed_users - 1,"
		+ " reading_users = reading_users + 1"
		+ " where book_id = :bookId",
		nativeQuery = true)
	void updateReadDatasReading(String bookId, Integer accumTime);

	@Transactional
	@Modifying
	@Query(value = "update dokki.book_statistics "
		+ "set mean_read_time = "
		+ "ifnull((mean_read_time * completed_users) - :accumTime) / (completed_users - 1), 0)"
		+ ", completed_users = completed_users - 1 "
		+ " where book_id = :bookId",
		nativeQuery = true)
	void updateReadDatasDeleteComplete(String bookId, Integer accumTime);

}
