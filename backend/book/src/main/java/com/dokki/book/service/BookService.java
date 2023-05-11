package com.dokki.book.service;


import com.dokki.book.client.ReviewClient;
import com.dokki.book.config.exception.CustomException;
import com.dokki.book.dto.response.AladinItemResponseDto;
import com.dokki.book.dto.response.AladinSearchResponseDto;
import com.dokki.book.entity.BookEntity;
import com.dokki.book.entity.BookStatisticsEntity;
import com.dokki.book.enums.SearchType;
import com.dokki.book.repository.BookRepository;
import com.dokki.book.repository.BookStatisticsRepository;
import com.dokki.book.util.AladinCaller;
import com.dokki.util.common.error.ErrorCode;
import com.dokki.util.review.dto.response.CommentResponseDto;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Slice;
import org.springframework.data.domain.SliceImpl;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.util.List;
import java.util.Optional;


@Slf4j
@RequiredArgsConstructor
@Service
public class BookService {

	private final BookRepository bookRepository;
	private final BookStatisticsRepository bookStatisticsRepository;
	private final ReviewClient reviewClient;


	/**
	 * 책 검색
	 *
	 * @param search    검색어
	 * @param queryType 검색 타입
	 * @param pageable  페이징
	 */
	public Slice<AladinItemResponseDto> searchBookList(String search, SearchType queryType, Pageable pageable) {
		AladinSearchResponseDto result;
		try {
			search = search.replaceAll(" ", "%20"); // url상에 공백 -> URL escape code로 대체
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
	public BookEntity getBook(String bookId) {
		BookEntity result;
		Optional<BookEntity> bookEntity = bookRepository.findById(bookId);

		result = bookEntity.orElseGet(() -> saveBookUseAladin(bookId));
		return result;
	}


	/**
	 * 도서 요약 정보를 조회합니다.
	 *
	 * @param bookId
	 * @return
	 */
	public BookEntity getSimpleBook(String bookId) {
		return bookRepository.findById(bookId).orElseThrow(() -> new CustomException(ErrorCode.NOTFOUND_RESOURCE));
	}


	/**
	 * 도서 요약 정보 리스트를 조회합니다.
	 *
	 * @param bookIdList 책 id 리스트
	 * @return
	 */
	public List<BookEntity> getBookListByIdIn(List<String> bookIdList) {
		return bookRepository.findByIdIn(bookIdList);
	}


	/**
	 * 책 리뷰 3개 리턴
	 *
	 * @param bookId 책 id
	 * @return 해당 책의 리뷰 3개
	 */
	public List<CommentResponseDto> get3Comment(String bookId) {
		return reviewClient.get3Comment(bookId);
	}


	/**
	 * 알라딘에서 책 세부정보 가져와서 저장, 저장된 정보 리턴
	 * 서비스 내부에서 사용
	 */
	protected BookEntity saveBookUseAladin(String bookId) {
		AladinItemResponseDto detailResponse;
		try {
			detailResponse = AladinCaller.getBook(bookId);
		} catch (IOException e) {
			throw new RuntimeException(e);
		}
		// 책 뒷면, 옆면 이미지 url 유효 확인
		String[] otherPath = AladinCaller.getOtherCoverPath(detailResponse.getCover());
		boolean isValidCoverBackImagePath = AladinCaller.isValidUrl(otherPath[0]);
		boolean isValidCoverSideImagePath = AladinCaller.isValidUrl(otherPath[1]);

		// 유효하지 않은 url은 null 처리
		if (!isValidCoverBackImagePath) otherPath[0] = null;
		if (!isValidCoverSideImagePath) otherPath[1] = null;

		// 책 정보 저장
		BookEntity bookEntity = bookRepository.save(AladinItemResponseDto.toEntity(detailResponse, otherPath));

		// 책 통계 정보 init, 저장
		bookStatisticsRepository.save(new BookStatisticsEntity(bookEntity));
		return bookEntity;
	}


	/**
	 * 책 존재여부 확인, 존재하지 않다면 bookId로 검색 후 저장
	 * 서비스 내부에서 사용
	 */
	protected BookEntity getBookReferenceIfExist(String bookId) {
		// check book exist, if not -> saveBook
		boolean isBookExist = bookRepository.existsById(bookId);
		if (!isBookExist) {
			saveBookUseAladin(bookId);
		}
		return bookRepository.getReferenceById(bookId);
	}

}
