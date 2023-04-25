package com.dokki.book.client;


import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;


@FeignClient(name = "review-service") // microservice name
public interface ReviewClient {
	/**
	 *        @GetMapping("/reviews/comment/partial/{bookId}")
	 *    @ApiOperation(value = "해당 도서에 대한 리뷰(Comment) 3개 조회")
	 * 	public ResponseEntity<List<CommentResponseDto>> get3Comment(@PathVariable String bookId) {
	 * 		List<CommentEntity> commentEntityList = commentService.get3Comment(bookId);
	 * 		List<CommentResponseDto> commentResponseDtoList = CommentResponseDto.fromEntityList(commentEntityList);
	 * 		return ResponseEntity.ok(commentResponseDtoList);
	 *    }
	 */

	@GetMapping("/reviews/comment/partial/{bookId}")
	public List<CommentResponseDto>
}
