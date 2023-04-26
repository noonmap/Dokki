package com.dokki.book.service;


import com.dokki.book.repository.BookRepository;
import com.dokki.book.repository.BookStatusRepository;
import com.dokki.book.dto.response.BookTimerResponseDto;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;


@Slf4j
@Service
@RequiredArgsConstructor
public class BookTimerService {

	private final BookRepository bookRepository;
	private final BookStatusRepository bookStatusRepository;


	/**
	 * [타이머 뷰] 읽고 있는 도서 목록 조회
	 *
	 * @param pageable
	 * @return 읽고있는 도서 목록
	 */

	public Page<BookTimerResponseDto> getBookTimerList(Long userId, Pageable pageable) {
		return Page.empty();
	}


	/**
	 * [타이머 뷰] 읽고 있는 도서 삭제
	 *
	 * @param bookId 책 id
	 * @param userId 유저 id
	 */
	public void deleteBookTimer(String bookId, Long userId) {
	}

}
