package com.dokki.review.client;


import com.dokki.util.book.dto.response.BookSimpleResponseDto;
import com.dokki.util.book.dto.response.CollectionSimpleResponseDto;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;

import java.util.List;


@FeignClient(name = "book-service")
public interface BookClient {

	/**
	 * 도서 요약 정보를 조회합니다.
	 *
	 * @param bookId
	 * @return
	 */
	@GetMapping("/books/simple/{bookId}")
	BookSimpleResponseDto getBookSimple(@PathVariable String bookId);
	/**
	 * 도서 요약 정보를 목록으로 한번에 조회합니다.
	 *
	 * @param bookIdList
	 * @return
	 */
	@PostMapping("/books/simple/list/{bookId}")
	List<BookSimpleResponseDto> getBookSimple(@RequestBody List<String> bookIdList);

	/**
	 * 도서 컬렉션 정보를 조회합니다. (bookStatusId 조회)
	 *
	 * @param bookid
	 * @return
	 */
	@GetMapping("/books/read-book/simple/{bookId}")
	CollectionSimpleResponseDto getCollectionSimple(@PathVariable String bookid);

}
