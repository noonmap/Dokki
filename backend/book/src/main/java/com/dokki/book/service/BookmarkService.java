package com.dokki.book.service;


import com.dokki.book.entity.BookEntity;
import com.dokki.book.repository.BookRepository;
import com.dokki.book.repository.BookmarkRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
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
	 * @param pageable
	 * @return 유저가 찜한 책 페이지 객체
	 */
	public Page<BookEntity> getBookmarkList(Long userId, @RequestParam Pageable pageable) {
		return null;
	}


	/**
	 * 책 찜하기 추가
	 *
	 * @param bookId 책 id
	 */
	public void createBookmark(String bookId) {
	}


	/**
	 * 책 찜하기 삭제
	 *
	 * @param bookId 책 id
	 */
	public void deleteBookmark(String bookId) {
	}

}
