package com.dokki.book.service;


import com.dokki.book.dto.response.BookDetailResponseDto;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import org.springframework.stereotype.Service;


@Log4j2
@Service
@RequiredArgsConstructor
public class BookService {

	/**
	 * 책 상세정보 조회
	 *
	 * @param bookId 책 id
	 * @return 책 정보 + 리뷰 정보
	 */
	public BookDetailResponseDto getBook(String bookId) {
		return null;
	}

}
