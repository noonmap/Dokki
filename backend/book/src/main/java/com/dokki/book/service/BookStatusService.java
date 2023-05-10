package com.dokki.book.service;


import com.dokki.book.client.TimerClient;
import com.dokki.book.config.exception.CustomException;
import com.dokki.book.dto.UserBookInfoDto;
import com.dokki.book.dto.request.BookCompleteRequestDto;
import com.dokki.book.entity.BookEntity;
import com.dokki.book.entity.BookStatusEntity;
import com.dokki.book.repository.BookStatusRepository;
import com.dokki.util.common.error.ErrorCode;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Slice;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Objects;


@Slf4j
@Service
@RequiredArgsConstructor
public class BookStatusService {

	private final String STATUS_IN_PROGRESS = "T";
	private final String STATUS_DONE = "F";

	private final BookService bookService;
	private final BookStatusRepository bookStatusRepository;
	private final BookmarkService bookmarkService;

	private final TimerClient timerClient;


	/**
	 * 타이머에 도서 추가
	 */
	public void createBookToTimer(Long userId, String bookId) {
		BookStatusEntity statusEntity = getStatusByUserIdAndBookId(userId, bookId);

		if (statusEntity == null) {
			createStatus(userId, bookId, STATUS_IN_PROGRESS);
		} else {
			modifyStatusToInprogress(userId, statusEntity);
		}
	}


	/**
	 * 책 완독 추가
	 */
	public void createPastBookDone(Long userId, BookCompleteRequestDto dto) {
		createStatus(userId, dto.getBookId(), STATUS_DONE);
		System.out.println(dto.getStartTime());
		//		timerClient 요청하기
	}


	/**
	 * 도서 상태 추가
	 *
	 * @param userId 유저 id
	 * @param bookId 책 id
	 */
	public BookStatusEntity createStatus(Long userId, String bookId, String status) {
		return bookStatusRepository.save(BookStatusEntity.builder()
			.userId(userId)
			.bookId(bookService.getBookReferenceIfExist(bookId))
			.status(status)
			.build());
	}


	/**
	 * 도서 상태 변경
	 * ⇒ 완독(컬렉션) → 진행중(타이머)
	 */
	public void modifyStatusToInprogress(Long userId, BookStatusEntity statusEntity) {

		// 로그인한 유저의 책이 맞는지 확인
		if (!Objects.equals(statusEntity.getUserId(), userId)) {
			throw new CustomException(ErrorCode.INVALID_REQUEST);
		}

		// 상태 변경
		statusEntity.setStatus(STATUS_IN_PROGRESS);
		bookStatusRepository.save(statusEntity);
	}


	/**
	 * 완독
	 * (도서 상태 변경)
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


	/**
	 * 다 읽은 책 컬렉션 조회
	 *
	 * @param userId   유저 id
	 * @param pageable 페이징
	 * @return 컬렉션 리스트
	 */
	public Slice<BookStatusEntity> getCollectionList(Long userId, Pageable pageable) {
		return bookStatusRepository.getByUserIdAndStatusEquals(userId, STATUS_DONE, pageable);
	}


	/**
	 * 다 읽은 책 컬렉션에서 삭제
	 *
	 * @param bookStatusId 책 상태 id
	 */
	@Transactional
	public void deleteCollection(Long userId, Long bookStatusId) {
		bookStatusRepository.deleteByIdAndUserId(bookStatusId, userId);
	}


	/**
	 * userId, bookId로 status 가져오기
	 */
	public BookStatusEntity getStatusByUserIdAndBookId(Long userId, String bookId) {
		BookEntity bookEntity = bookService.getBookReferenceIfExist(bookId);
		return bookStatusRepository.findTopByUserIdAndBookId(userId, bookEntity);
	}


	/**
	 * id로 status 가져오기
	 */
	public BookStatusEntity getBookStatus(Long bookStatusId) {
		return bookStatusRepository.findById(bookStatusId).orElseThrow(() -> new CustomException(ErrorCode.NOTFOUND_RESOURCE));
	}


	public UserBookInfoDto getUserBookInfo(Long userId, String bookId) {
		// 북마크 여부
		BookEntity bookEntity = bookService.getBookReferenceIfExist(bookId);
		boolean isBookMarked = bookmarkService.isBookmarkedByUserIdAndBookEntity(userId, bookEntity);

		// 읽고있는, 다읽은 책 여부
		BookStatusEntity bookStatusEntity = getStatusByUserIdAndBookId(userId, bookId);
		boolean isReading = false;
		boolean isComplete = false;
		if (bookStatusEntity != null) {
			isReading = bookStatusEntity.getStatus().equals(STATUS_IN_PROGRESS);
			isComplete = !isReading;
		}

		return UserBookInfoDto.builder()
			.isReading(isReading)
			.isComplete(isComplete)
			.isBookMarked(isBookMarked)
			.build();
	}

}
