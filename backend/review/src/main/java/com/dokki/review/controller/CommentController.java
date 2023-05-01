package com.dokki.review.controller;


import com.dokki.review.dto.request.CommentRequestDto;
import com.dokki.review.entity.CommentEntity;
import com.dokki.review.service.CommentService;
import com.dokki.util.review.dto.response.CommentResponseDto;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Slice;
import org.springframework.data.domain.SliceImpl;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;


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
		Slice<CommentEntity> commentEntitySlice = commentService.getCommentListForBook(bookId, pageable);
		Slice<CommentResponseDto> commentResponseDtoSlice = commentEntitySlice.map(
			s -> CommentResponseDto.builder()
				.userId(s.getUserId())
				.nickname("유저닉네임")
				.profileImagePath("유저프로필이미지")
				.score(s.getScore().intValue())
				.content(s.getContent())
				.build());
		// 테스트
		List<CommentResponseDto> testList = new ArrayList<>();
		testList.add(CommentResponseDto.builder().userId(1L).nickname("아바낭").profileImagePath("/default/image.png").score(10).content("아바나아바나촤촤촷").build());
		testList.add(CommentResponseDto.builder().userId(1L).nickname("아바낭22").profileImagePath("/default/image.png").score(5).content("아바나아바나촤촤촷13").build());
		testList.add(CommentResponseDto.builder().userId(1L).nickname("아바낭34").profileImagePath("/default/image.png").score(7).content("아바나아바나촤촤촷22").build());
		testList.add(CommentResponseDto.builder().userId(1L).nickname("아바낭35").profileImagePath("/default/image.png").score(7).content("아바나아바나촤촤촷22").build());
		testList.add(CommentResponseDto.builder().userId(1L).nickname("아바낭6").profileImagePath("/default/image.png").score(7).content("아바나아바나촤촤촷22").build());
		testList.add(CommentResponseDto.builder().userId(1L).nickname("아바낭73").profileImagePath("/default/image.png").score(6).content("아바나아바나촤촤촷22").build());
		testList.add(CommentResponseDto.builder().userId(1L).nickname("아바낭38").profileImagePath("/default/image.png").score(9).content("아바나아바나촤촤촷22").build());
		testList.add(CommentResponseDto.builder().userId(1L).nickname("아바낭36").profileImagePath("/default/image.png").score(4).content("아바나아바나촤촤촷22").build());
		testList.add(CommentResponseDto.builder().userId(1L).nickname("아바낭39").profileImagePath("/default/image.png").score(1).content("아바나아바나촤촤촷22").build());
		testList.add(CommentResponseDto.builder().userId(1L).nickname("아바낭37").profileImagePath("/default/image.png").score(2).content("아바나아바나촤촤촷22").build());
		testList.add(CommentResponseDto.builder().userId(1L).nickname("아바낭340").profileImagePath("/default/image.png").score(3).content("아바나아바나촤촤촷22").build());
		boolean hasNext = false;
		if (testList.size() > pageable.getPageSize()) {
			hasNext = true;
		}
		Slice<CommentResponseDto> commentResponseDtoPage = new SliceImpl<>(testList, pageable, hasNext);//CommentResponseDto.fromEntityPage(commentEntityPage);
		return ResponseEntity.ok(commentResponseDtoPage);
	}


	@PostMapping("/{bookId}")
	@ApiOperation(value = "코멘트 추가")
	public ResponseEntity<Boolean> createComment(@PathVariable String bookId, @RequestBody CommentRequestDto commentRequestDto) {
		// TODO : userID를 나중에 채워야 함
		commentService.createComment(1L, bookId, commentRequestDto);
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
		commentService.deleteComment(commentId);
		return ResponseEntity.ok(true);
	}


	@GetMapping("/partial/{bookId}")
	@ApiOperation(value = "해당 도서에 대한 리뷰(Comment) 3개 조회")
	public ResponseEntity<List<CommentResponseDto>> get3Comment(@PathVariable String bookId) {
		List<CommentEntity> commentEntityList = commentService.get3Comment(bookId);
		List<CommentResponseDto> commentResponseDtoList = commentEntityList.stream().map(
			s -> CommentResponseDto.builder()
				.userId(s.getUserId())
				.nickname("유저닉네임")
				.profileImagePath("유저프로필이미지")
				.score(s.getScore().intValue())
				.content(s.getContent())
				.build()).collect(Collectors.toList());
		// test 반환값
		commentResponseDtoList = new ArrayList<>(); //CommentResponseDto.fromEntityList(commentEntityList);
		commentResponseDtoList.add(CommentResponseDto.builder().content("리뷰리뷰").created(LocalDateTime.now()).score(4).build());
		commentResponseDtoList.add(CommentResponseDto.builder().content("리이뷰").created(LocalDateTime.now()).score(5).build());
		commentResponseDtoList.add(CommentResponseDto.builder().content("리이뷰222").created(LocalDateTime.now()).score(5).build());
		return ResponseEntity.ok(commentResponseDtoList);
	}

}
