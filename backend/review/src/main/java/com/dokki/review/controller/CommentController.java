package com.dokki.review.controller;


import com.dokki.review.dto.request.CommentRequestDto;
import com.dokki.review.service.CommentService;
import com.dokki.util.common.utils.SessionUtils;
import com.dokki.util.review.dto.response.CommentResponseDto;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Slice;
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
	public ResponseEntity<Slice<CommentResponseDto>> getCommentListForBook(@PathVariable String bookId, Pageable pageable) {
		Slice<CommentResponseDto> commentResponseDtoSlice = commentService.getCommentListForBook(bookId, pageable);
		return ResponseEntity.ok(commentResponseDtoSlice);
	}


	@PostMapping("/{bookId}")
	@ApiOperation(value = "코멘트 추가")
	public ResponseEntity<Boolean> createComment(@PathVariable String bookId, @RequestBody CommentRequestDto commentRequestDto) {
		Long userId = SessionUtils.getUserId();
		commentService.createComment(userId, bookId, commentRequestDto);
		return ResponseEntity.ok(true);
	}


	@PutMapping("/{commentId}")
	@ApiOperation(value = "코멘트 수정")
	public ResponseEntity<Boolean> modifyComment(@PathVariable Long commentId, @RequestBody CommentRequestDto commentRequestDto) {
		// TODO : userID를 나중에 채워야 함
		commentService.modifyComment(1L, commentId, commentRequestDto);
		return ResponseEntity.ok(true);
	}


	@DeleteMapping("/{commentId}")
	@ApiOperation(value = "코멘트 삭제")
	public ResponseEntity<Boolean> deleteComment(@PathVariable Long commentId) {
		// TODO : userID를 나중에 채워야 함
		commentService.deleteComment(1L, commentId);
		return ResponseEntity.ok(true);
	}


	@GetMapping("/partial/{bookId}")
	@ApiOperation(value = "해당 도서에 대한 리뷰(Comment) 3개 조회")
	public ResponseEntity<List<CommentResponseDto>> get3Comment(@PathVariable String bookId) {
		List<CommentResponseDto> commentResponseDtoList = commentService.get3Comment(bookId);
		//		// test 반환값
		//		commentResponseDtoList = new ArrayList<>(); //CommentResponseDto.fromEntityList(commentEntityList);
		//		commentResponseDtoList.add(CommentResponseDto.builder().userId(0L).nickname("닉").commentId(0L).content("리뷰리뷰")
		//			.profileImagePath("https://upload.wikimedia.org/wikipedia/commons/thumb/0/08/Shin_Min_A.jpg/250px-Shin_Min_A.jpg").created(LocalDateTime.now()).score(4).build());
		//		commentResponseDtoList.add(CommentResponseDto.builder().userId(0L).nickname("닉").commentId(1L).content("리이뷰")
		//			.profileImagePath("https://upload.wikimedia.org/wikipedia/commons/thumb/0/08/Shin_Min_A.jpg/250px-Shin_Min_A.jpg").created(LocalDateTime.now()).score(5).build());
		//		commentResponseDtoList.add(CommentResponseDto.builder().userId(1L).nickname("넥").commentId(3L).content("리이뷰222")
		//			.profileImagePath("https://upload.wikimedia.org/wikipedia/commons/thumb/0/08/Shin_Min_A.jpg/250px-Shin_Min_A.jpg").created(LocalDateTime.now()).score(5).build());
		return ResponseEntity.ok(commentResponseDtoList);
	}

}
