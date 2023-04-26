package com.dokki.book.service;


import com.dokki.book.entity.BookEntity;
import com.dokki.book.enums.SearchType;
import com.dokki.book.repository.BookRepository;
import com.dokki.util.book.dto.response.BookDetailResponseDto;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;


@Slf4j
@Service
@RequiredArgsConstructor
public class BookService {

	private final BookRepository bookRepository;


	/**
	 * 책 검색
	 *
	 * @param search    검색어
	 * @param queryType 검색 타입
	 * @param pageable
	 */
	public List<Object> searchBookList(String search, @RequestParam SearchType queryType, @RequestParam Pageable pageable) {
		return null;
	}


	/**
	 * 책 상세정보 조회
	 *
	 * @param bookId 책 id
	 * @return 책 정보 + 리뷰 정보
	 */
	public BookDetailResponseDto getBook(String bookId) {
		return null;
	}


	/**
	 * 도서 요약 정보를 조회합니다.
	 *
	 * @param bookId
	 * @return
	 */
	public BookEntity getSimpleBook(String bookId) {
		return BookEntity.builder().build();
	}

}
