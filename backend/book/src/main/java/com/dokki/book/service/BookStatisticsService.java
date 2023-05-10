package com.dokki.book.service;


import com.dokki.book.config.exception.CustomException;
import com.dokki.book.repository.BookStatisticsRepository;
import com.dokki.util.common.error.ErrorCode;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;


@Slf4j
@Service
@RequiredArgsConstructor
public class BookStatisticsService {

	private final BookStatisticsRepository bookStatisticsRepository;


	public void modifyReviewScore(String bookId, Float avgScore) {
		int row = bookStatisticsRepository.updateMeanScore(bookId, avgScore);
		if (row != 1) {
			throw new CustomException(ErrorCode.NOTFOUND_RESOURCE);
		}
	}

}
