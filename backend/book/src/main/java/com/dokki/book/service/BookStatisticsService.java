package com.dokki.book.service;


import com.dokki.book.repository.BookStatisticsRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;


@Slf4j
@Service
@RequiredArgsConstructor
public class BookStatisticsService {

	private final BookStatisticsRepository bookStatisticsRepository;


	public void modifyReviewScore(String bookId, Float avgScore) {
		bookStatisticsRepository.updateMeanScore(bookId, avgScore);
	}

}
