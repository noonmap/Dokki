package com.dokki.review.client;


import com.dokki.util.book.dto.response.BookSimpleResponseDto;
import com.dokki.util.book.dto.response.CollectionSimpleResponseDto;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.*;

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
	 * @param bookId
	 * @return
	 */
	@GetMapping("/books/read-book/simple/{bookId}")
	CollectionSimpleResponseDto getCollectionSimple(@PathVariable String bookId);

	/**
	 * book의 정보 중, 리뷰 평균 score 를 수정합니다.
	 * - 리뷰 추가 / 삭제시 호출
	 *
	 * @param bookId
	 * @param avgScore
	 */
	@PostMapping("/books/statistics/{bookId}/review")
	void updateAverageScore(@PathVariable String bookId, @RequestParam Float avgScore);

}
