package com.dokki.review.service;


import com.dokki.review.entity.CommentEntity;
import com.dokki.review.repository.CommentRepository;
import com.dokki.review.dto.request.CommentRequestDto;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;


@Log4j2
@Service
@RequiredArgsConstructor
public class CommentService {

	private final CommentRepository commentRepository;


	/**
	 * 코멘트 목록 조회
	 *
	 * @param bookId
	 * @param pageable
	 * @return
	 */
	public Page<CommentEntity> getCommentList(String bookId, Pageable pageable) {
		return Page.empty();
	}


	/**
	 * 코멘트 생성
	 *
	 * @param bookId
	 * @param commentRequestDto
	 */
	public void createComment(String bookId, CommentRequestDto commentRequestDto) {
	}


	/**
	 * 코멘트 수정
	 *
	 * @param commentId
	 * @param commentRequestDto
	 */
	public void modifyComment(Long commentId, CommentRequestDto commentRequestDto) {
	}


	/**
	 * 코멘트 삭제
	 *
	 * @param commentId
	 */
	public void deleteComment(Long commentId) {
	}


	/**
	 * 코멘트 3개 조회
	 *
	 * @param bookId
	 * @return
	 */
	public List<CommentEntity> get3Comment(String bookId) {
		return new ArrayList<>();
	}

}
