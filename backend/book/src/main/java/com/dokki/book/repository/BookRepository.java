package com.dokki.book.repository;


import com.dokki.book.entity.BookEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;


@Repository
public interface BookRepository extends JpaRepository<BookEntity, String> {

	List<BookEntity> findByIdIn(List<String> idList);

}
