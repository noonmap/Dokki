package com.dokki.review.controller;


import com.dokki.review.dto.request.CommentRequestDto;
import com.dokki.review.dto.response.CommentResponseDto;
import com.dokki.review.entity.CommentEntity;
import com.dokki.review.service.CommentService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;


@Log4j2
@RestController
@RequestMapping("/reviews/comment")
@RequiredArgsConstructor
@Api(tags = "도서 코멘트 (한줄 평) API")
public class CommentController {

	private final CommentService commentService;


	@GetMapping("/{bookId}")
	@ApiOperation(value = "도서의 리뷰(코멘트) 목록 조회")
	public ResponseEntity<Page<CommentResponseDto>> getCommentList(@PathVariable String bookId, Pageable pageable) {
		Page<CommentEntity> commentEntityPage = commentService.getCommentList(bookId, pageable);
		Page<CommentResponseDto> commentResponseDtoPage = CommentResponseDto.fromEntityPage(commentEntityPage);
		return ResponseEntity.ok(commentResponseDtoPage);
	}


	@PostMapping("/{bookId}")
	@ApiOperation(value = "코멘트 추가")
	public ResponseEntity<Boolean> createComment(@PathVariable String bookId, @RequestBody CommentRequestDto commentRequestDto) {
		commentService.createComment(bookId, commentRequestDto);
		return ResponseEntity.ok(true);
	}


	@PutMapping("/{commentId}")
	@ApiOperation(value = "코멘트 수정")
	public ResponseEntity<Boolean> modifyComment(@PathVariable Long commentId, @RequestBody CommentRequestDto commentRequestDto) {
		commentService.modifyComment(commentId, commentRequestDto);
		return ResponseEntity.ok(true);
	}


	@DeleteMapping("/{commentId}")
	@ApiOperation(value = "코멘트 삭제")
	public ResponseEntity<Boolean> deleteComment(@PathVariable Long commentId) {
		commentService.deleteComment(commentId);
		return ResponseEntity.ok(true);
	}


	@GetMapping("/reviews/comment/partial/{bookId}")
	@ApiOperation(value = "해당 도서에 대한 리뷰(Comment) 3개 조회")
	public ResponseEntity<List<CommentResponseDto>> get3Comment(@PathVariable String bookId) {
		List<CommentEntity> commentEntityList = commentService.get3Comment(bookId);
		List<CommentResponseDto> commentResponseDtoList = CommentResponseDto.fromEntityList(commentEntityList);
		return ResponseEntity.ok(commentResponseDtoList);
	}

}
