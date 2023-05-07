package com.dokki.timer.client;


import com.dokki.util.book.dto.response.BookSimpleResponseDto;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;


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

	@GetMapping("/books/read-book/{bookStatusId}")
	String getBookIdByBookStatusId(@PathVariable(value = "bookStatusId") Long bookStatusId);
}
