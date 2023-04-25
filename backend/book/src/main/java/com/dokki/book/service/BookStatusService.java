package com.dokki.book.service;


import com.dokki.book.repository.BookStatusRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import org.springframework.stereotype.Service;


@Log4j2
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
