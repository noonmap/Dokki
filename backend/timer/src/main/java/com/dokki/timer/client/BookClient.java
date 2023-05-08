package com.dokki.timer.client;


import com.dokki.util.book.dto.response.BookSimpleResponseDto;
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
	BookSimpleResponseDto getBookSimple(@PathVariable(value = "bookId") String bookId);

	/**
	 * 도서 요약 정보를 목록으로 한번에 조회합니다.
	 *
	 * @param bookIdList
	 * @return
	 */
	@PostMapping("/books/simple/list/{bookId}")
	List<BookSimpleResponseDto> getBookSimple(@RequestBody List<String> bookIdList);

	@GetMapping("/books/read-book/{bookStatusId}")
	String getBookIdByBookStatusId(@PathVariable(value = "bookStatusId") Long bookStatusId);
}
