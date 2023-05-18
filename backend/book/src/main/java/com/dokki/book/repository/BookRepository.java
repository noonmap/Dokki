package com.dokki.book.repository;


import com.dokki.book.entity.BookEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;


@Repository
public interface BookRepository extends JpaRepository<BookEntity, String> {

	@Query(value = "select b from BookEntity b  where b.id in :idList ORDER BY FIELD(b.id, :idList)")
	List<BookEntity> findByIdInOrderByIdList(@Param("idList") List<String> idList);

}
