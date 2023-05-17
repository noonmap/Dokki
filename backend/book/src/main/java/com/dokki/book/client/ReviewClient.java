package com.dokki.book.client;


import com.dokki.util.review.dto.response.CommentResponseDto;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

import java.util.List;


@FeignClient(name = "review-service") // microservice name
public interface ReviewClient {

	/**
	 * 해당 도서에 대한 리뷰(Comment) 3개 조회
	 *
	 * @param bookId
	 * @return
	 */
	@GetMapping("/reviews/comment/partial/{bookId}")
	public List<CommentResponseDto> get3Comment(@PathVariable(value = "bookId") String bookId);

}
