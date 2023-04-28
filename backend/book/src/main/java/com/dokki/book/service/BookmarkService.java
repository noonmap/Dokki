package com.dokki.book.service;


import com.dokki.book.config.exception.CustomException;
import com.dokki.book.entity.BookEntity;
import com.dokki.book.entity.BookMarkEntity;
import com.dokki.book.repository.BookRepository;
import com.dokki.book.repository.BookmarkRepository;
import com.dokki.util.common.error.ErrorCode;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Slice;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.RequestParam;


@Slf4j
@Service
@RequiredArgsConstructor
public class BookmarkService {

	private final BookRepository bookRepository;
	private final BookmarkRepository bookmarkRepository;


	/**
	 * 찜한 책 조회
	 *
	 * @param userId   유저 id
	 * @param pageable 페이징
	 * @return 유저가 찜한 책 페이지 객체
	 */
	public Slice<BookMarkEntity> getBookmarkList(Long userId, @RequestParam Pageable pageable) {
		return bookmarkRepository.findSliceByUserId(userId, pageable);
	}


	/**
	 * 책 찜하기 추가
	 *
	 * @param bookId 책 id
	 */
	public void createBookmark(Long userId, String bookId) {
		isBookExist(bookId);
		BookEntity bookEntity = bookRepository.getReferenceById(bookId);

		// check bookmark already exist
		boolean isBookmarkExist = bookmarkRepository.existsByUserIdAndBookId(userId, bookEntity);
		if (isBookmarkExist) {
			throw new CustomException(ErrorCode.INVALID_REQUEST);
		}

		bookmarkRepository.save(new BookMarkEntity(null, userId, bookEntity));
	}


	/**
	 * 책 찜하기 삭제
	 *
	 * @param bookId 책 id
	 */
	@Transactional
	public void deleteBookmark(Long userId, String bookId) {
		isBookExist(bookId);
		BookEntity bookEntity = bookRepository.getReferenceById(bookId);
		bookmarkRepository.deleteByUserIdAndBookId(userId, bookEntity);
	}


	/**
	 * 책 존재여부 확인, 존재하지 않다면 exception
	 * 서비스 내부에서 사용
	 */
	private void isBookExist(String bookId) {
		// check book exist, if not -> error
		boolean isBookExist = bookRepository.existsById(bookId);
		if (!isBookExist) {
			throw new CustomException(ErrorCode.NOTFOUND_RESOURCE);
		}
	}

}
