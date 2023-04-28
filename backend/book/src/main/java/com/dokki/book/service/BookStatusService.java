package com.dokki.book.service;


import com.dokki.book.config.exception.CustomException;
import com.dokki.book.entity.BookStatusEntity;
import com.dokki.book.repository.BookStatusRepository;
import com.dokki.util.common.error.ErrorCode;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.Objects;


@Slf4j
@Service
@RequiredArgsConstructor
public class BookStatusService {

	private final String STATUS_IN_PROGRESS = "T";
	private final String STATUS_DONE = "F";

	private final BookService bookService;
	private final BookStatusRepository bookStatusRepository;


	/**
	 * 도서 상태 변경
	 * ⇒ 완독(컬렉션) → 진행중(타이머)
	 *
	 * @param userId 유저 id
	 * @param bookId 책 id
	 */
	public void createStatus(Long userId, String bookId) {
		bookStatusRepository.save(BookStatusEntity.builder()
			.userId(userId)
			.bookId(bookService.getBookReferenceIfExist(bookId))
			.status(STATUS_IN_PROGRESS)
			.build());
	}


	/**
	 * 도서 상태 변경
	 * ⇒ 완독(컬렉션) → 진행중(타이머)
	 *
	 * @param bookStatusId 유저 책 상태 id
	 */
	public void modifyStatusToInprogress(Long userId, Long bookStatusId) {
		BookStatusEntity statusEntity = bookStatusRepository.findById(bookStatusId).orElseThrow(() -> new CustomException(ErrorCode.NOTFOUND_RESOURCE));

		// 로그인한 유저의 책이 맞는지 확인
		if (!Objects.equals(statusEntity.getUserId(), userId)) {
			throw new CustomException(ErrorCode.INVALID_REQUEST);
		}

		// 상태 변경
		statusEntity.setStatus(STATUS_IN_PROGRESS);
		bookStatusRepository.save(statusEntity);
	}


	/**
	 * 도서 상태 변경
	 * ⇒ 진행중(타이머) → 완독(컬렉션)
	 *
	 * @param bookStatusId 유저 책 상태 id
	 */
	public void modifyStatusToDone(Long userId, Long bookStatusId) {
		BookStatusEntity statusEntity = bookStatusRepository.findById(bookStatusId).orElseThrow(() -> new CustomException(ErrorCode.NOTFOUND_RESOURCE));

		// 로그인한 유저의 책이 맞는지 확인
		if (!Objects.equals(statusEntity.getUserId(), userId)) {
			throw new CustomException(ErrorCode.INVALID_REQUEST);
		}

		// 상태 변경
		statusEntity.setStatus(STATUS_DONE);
		bookStatusRepository.save(statusEntity);
	}

}
