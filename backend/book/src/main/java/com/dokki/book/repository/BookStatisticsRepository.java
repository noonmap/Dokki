package com.dokki.book.repository;


import com.dokki.book.entity.BookStatisticsEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;


@Repository
public interface BookStatisticsRepository extends JpaRepository<BookStatisticsEntity, Long> {
}
