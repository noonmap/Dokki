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

	private final BookService bookService;

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
		BookEntity bookEntity = bookService.getBookReferenceIfExist(bookId);

		// check bookmark already exist
		if (isBookmarkedByUserIdAndBookEntity(userId, bookEntity)) {
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
		bookmarkRepository.deleteByUserIdAndBookId(userId, bookService.getBookReferenceIfExist(bookId));
	}


	/**
	 * 유저 아이디와 책 엔티티로 북마크 여부 확인
	 */
	protected Boolean isBookmarkedByUserIdAndBookEntity(Long userId, BookEntity bookEntity) {
		return bookmarkRepository.existsByUserIdAndBookId(userId, bookEntity);
	}

}
