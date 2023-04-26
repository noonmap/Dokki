package com.dokki.book.service;


import com.dokki.book.config.exception.CustomException;
import com.dokki.book.dto.response.AladinItemResponseDto;
import com.dokki.book.dto.response.AladinSearchResponseDto;
import com.dokki.book.dto.response.BookDetailResponseDto;
import com.dokki.book.entity.BookEntity;
import com.dokki.book.enums.SearchType;
import com.dokki.book.repository.BookRepository;
import com.dokki.book.util.AladinCaller;
import com.dokki.util.common.error.ErrorCode;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Slice;
import org.springframework.data.domain.SliceImpl;
import org.springframework.stereotype.Service;

import java.io.IOException;


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
	 * @param pageable  페이징
	 */
	public Slice<AladinItemResponseDto> searchBookList(String search, SearchType queryType, Pageable pageable) {
		AladinSearchResponseDto result = null;
		try {
			result = AladinCaller.searchBook(search, queryType, pageable);
		} catch (RuntimeException e) {
			log.error("BookService - 알라딘 api 에러 {}", e.getMessage());
			throw new CustomException(ErrorCode.UNKNOWN_ERROR);
		} catch (IOException e) {
			log.error("BookService - 검색어: {}", search);
			throw new CustomException(ErrorCode.INVALID_REQUEST);
		}
		boolean hasNext = pageable.getPageSize() * pageable.getPageNumber() < result.getTotalResults(); // 다음 slice 있는지 확인 계산
		return new SliceImpl<>(result.getItem(), pageable, hasNext);
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
