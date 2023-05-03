package com.dokki.book.service;


import com.dokki.book.config.exception.CustomException;
import com.dokki.book.entity.BookStatusEntity;
import com.dokki.book.repository.BookRepository;
import com.dokki.book.repository.BookStatusRepository;
import com.dokki.util.common.error.ErrorCode;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Slice;
import org.springframework.stereotype.Service;

import java.util.Objects;


@Slf4j
@Service
@RequiredArgsConstructor
public class BookTimerService {

	private final String STATUS_IN_PROGRESS = "T";
	private final String STATUS_DONE = "F";

	private final BookRepository bookRepository;
	private final BookStatusRepository bookStatusRepository;


	/**
	 * [타이머 뷰] 읽고 있는 도서 목록 조회
	 *
	 * @param pageable
	 * @return 읽고있는 도서 목록
	 */

	public Slice<BookStatusEntity> getBookTimerList(Long userId, Pageable pageable) {
		return bookStatusRepository.getByUserIdAndStatusEquals(userId, STATUS_IN_PROGRESS, pageable);
	}


	/**
	 * [타이머 뷰] 읽고 있는 도서 삭제
	 *
	 * @param bookStatusId
	 * @param userId       유저 id
	 */
	public void deleteBookTimer(Long bookStatusId, Long userId) {
		BookStatusEntity statusEntity = bookStatusRepository.findById(bookStatusId).orElseThrow(() -> new CustomException(ErrorCode.NOTFOUND_RESOURCE));

		// 로그인한 유저의 책이 맞는지 확인
		if (!Objects.equals(statusEntity.getUserId(), userId)) {
			throw new CustomException(ErrorCode.INVALID_REQUEST);
		}
		bookStatusRepository.deleteById(bookStatusId);
	}

}
