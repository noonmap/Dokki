package com.dokki.review.service;


import com.dokki.review.config.exception.CustomException;
import com.dokki.review.dto.request.CommentRequestDto;
import com.dokki.review.entity.CommentEntity;
import com.dokki.review.repository.CommentRepository;
import com.dokki.util.common.error.ErrorCode;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Slice;
import org.springframework.stereotype.Service;

import java.util.List;


@Log4j2
@Service
@RequiredArgsConstructor
public class CommentService {

	private final CommentRepository commentRepository;


	/**
	 * 도서의 코멘트 목록 조회
	 *
	 * @param bookId
	 * @param pageable
	 * @return
	 */
	public Slice<CommentEntity> getCommentListForBook(String bookId, Pageable pageable) {
		Slice<CommentEntity> commentEntityPage = commentRepository.findByBookIdOrderByCreatedAtDesc(bookId, pageable);
		return commentEntityPage;
	}


	/**
	 * 코멘트 생성
	 *
	 * @param bookId
	 * @param commentRequestDto
	 */
	public void createComment(Long userId, String bookId, CommentRequestDto commentRequestDto) {
		CommentEntity comment = CommentEntity.builder()
			.userId(userId)
			.bookId(bookId)
			.content(commentRequestDto.getContent())
			.score(commentRequestDto.getScore().floatValue())
			.build();
		commentRepository.save(comment);
	}


	/**
	 * 코멘트 수정
	 *
	 * @param commentId
	 * @param commentRequestDto
	 */
	public void modifyComment(Long userId, Long commentId, CommentRequestDto commentRequestDto) {
		CommentEntity comment = commentRepository.findById(commentId).orElseThrow(() -> new CustomException(ErrorCode.NOTFOUND_RESOURCE));
		comment.updateContent(comment.getContent());
		comment.updateScore(comment.getScore());
		commentRepository.save(comment);
	}


	/**
	 * 코멘트 삭제
	 *
	 * @param commentId
	 */
	public void deleteComment(Long commentId) {
		if (!commentRepository.existsById(commentId)) {
			throw new CustomException(ErrorCode.NOTFOUND_RESOURCE);
		}
		commentRepository.deleteById(commentId);
	}


	/**
	 * 코멘트 3개 조회
	 *
	 * @param bookId
	 * @return
	 */
	public List<CommentEntity> get3Comment(String bookId) {
		List<CommentEntity> commentTop3 = commentRepository.findTop3ByBookIdOrderByCreatedAtDesc(bookId);
		return commentTop3;
	}

}
