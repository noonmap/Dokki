package com.dokki.book.service;


import com.dokki.book.repository.BookStatusRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;


@Slf4j
@Service
@RequiredArgsConstructor
public class BookStatusService {

	private final BookStatusRepository bookStatusRepository;


	/**
	 * 도서 상태 변경
	 * ⇒ 완독(컬렉션) → 진행중(타이머)
	 *
	 * @param bookId 책 id
	 */
	public void modifyStatusToInprogress(String bookId) {
	}


	/**
	 * 도서 상태 변경
	 * ⇒ 진행중(타이머) → 완독(컬렉션)
	 *
	 * @param bookId 책 id
	 */
	public void modifyStatusToDone(String bookId) {
	}

}
