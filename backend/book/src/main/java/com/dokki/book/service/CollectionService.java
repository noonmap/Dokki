package com.dokki.book.service;


import com.dokki.book.dto.response.CollectionResponseDto;
import com.dokki.book.repository.BookRepository;
import com.dokki.book.repository.BookStatusRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;


@Log4j2
@Service
@RequiredArgsConstructor
public class CollectionService {

	private final BookRepository bookRepository;
	private final BookStatusRepository bookStatusRepository;


	/**
	 * 다 읽은 책 컬렉션 조회
	 *
	 * @param userId   유저 id
	 * @param pageable 페이징
	 * @return 컬렉션 리스트
	 */
	public Page<CollectionResponseDto> getCollectionList(Long userId, Pageable pageable) {
		return Page.empty();
	}


	/**
	 * 다 읽은 책 컬렉션에서 삭제
	 *
	 * @param bookId 책 id
	 * @param userId 유저 id
	 */
	public void deleteCollection(String bookId, Long userId) {
	}

}
