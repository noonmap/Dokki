package com.dokki.book.repository;


import com.dokki.book.entity.BookStatusEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;


@Repository
public interface BookStatusRepository extends JpaRepository<BookStatusEntity, Long> {
}
