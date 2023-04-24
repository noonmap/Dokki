package com.dokki.book.repository;


import com.dokki.book.entity.BookMarkEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;


@Repository
public interface BookmarkRepository extends JpaRepository<BookMarkEntity, Long> {
}
