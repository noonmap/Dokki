package com.dokki.review.service;


import com.dokki.review.client.BookClient;
import com.dokki.review.client.UserClient;
import com.dokki.review.config.exception.CustomException;
import com.dokki.review.dto.request.CommentRequestDto;
import com.dokki.review.entity.CommentEntity;
import com.dokki.review.repository.CommentRepository;
import com.dokki.util.common.enums.DefaultEnum;
import com.dokki.util.common.error.ErrorCode;
import com.dokki.util.common.utils.FileUtils;
import com.dokki.util.review.dto.response.CommentResponseDto;
import com.dokki.util.user.dto.response.UserSimpleInfoDto;
import feign.FeignException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Slice;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.stream.Collectors;


@Slf4j
@Service
@RequiredArgsConstructor
public class CommentService {

	private final CommentRepository commentRepository;

	private final UserClient userClient;

	private final BookClient bookClient;


	/**
	 * commentEntity의 필드 값을 사용해서 CommentResponseDto 객체를 생성한 후 반환
	 * user정보는 Default값으로 채움
	 *
	 * @param commentEntity
	 * @return
	 */
	private CommentResponseDto createCommentResponseDto(CommentEntity commentEntity) {
		// user 정보를 default 값으로 대체
		UserSimpleInfoDto defaultUserInfo = UserSimpleInfoDto.builder()
			.userId(commentEntity.getUserId())
			.nickname(DefaultEnum.USER_NICKNAME.getValue())
			.profileImagePath(DefaultEnum.USER_PROFILE_IMAGE_PATH.getValue())
			.build();
		return createCommentResponseDto(commentEntity, defaultUserInfo);
	}


	/**
	 * commentEntity와 userSimpleInfoDto의 필드 값을 사용해서 CommentResponseDto 객체를 생성한 후 반환
	 *
	 * @param commentEntity
	 * @param userSimpleInfoDto
	 * @return
	 */
	private CommentResponseDto createCommentResponseDto(CommentEntity commentEntity, UserSimpleInfoDto userSimpleInfoDto) {
		return CommentResponseDto.builder()
			.userId(commentEntity.getUserId())
			.nickname(userSimpleInfoDto.getNickname())
			.profileImagePath(FileUtils.getAbsoluteFilePath(userSimpleInfoDto.getProfileImagePath()))
			.commentId(commentEntity.getId())
			.score(commentEntity.getScore().intValue())
			.content(commentEntity.getContent())
			.created(commentEntity.getCreatedAt())
			.build();
	}


	/**
	 * 도서의 코멘트 목록 조회
	 *
	 * @param bookId
	 * @param pageable
	 * @return
	 */
	public Slice<CommentResponseDto> getCommentListForBook(String bookId, Pageable pageable) {
		// comment 조회
		Slice<CommentEntity> commentEntityPage = commentRepository.findByBookIdOrderByCreatedAtDesc(bookId, pageable);

		// 각 comment의 writer id를 list로 생성
		List<Long> writerIdList = commentEntityPage.map(c -> c.getUserId()).toList();
		Slice<CommentResponseDto> commentResponseDtoSlice;

		// writer 정보 조회, writer의 정보를 comment와 연결, commentResponseDto로 매핑
		try {
			List<UserSimpleInfoDto> writerInfoList = userClient.getUserSimpleInfo(writerIdList);
			AtomicInteger counter = new AtomicInteger(0); // map()에서 index 역할
			commentResponseDtoSlice = commentEntityPage.map(
				c -> {
					int idx = counter.getAndIncrement();
					return createCommentResponseDto(c, writerInfoList.get(idx));
				}
			);
		} catch (FeignException e) {
			log.error(e.getMessage());
			// 조회 실패한 경우, 빈 값은 default value로 채움
			commentResponseDtoSlice = commentEntityPage.map(c -> createCommentResponseDto(c));
		}

		return commentResponseDtoSlice;
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

		// 도서 평균 점수 반영
		float avgScore = commentRepository.findAvgScoreByBookId(bookId);
		bookClient.updateAverageScore(bookId, avgScore);
		log.info("[CreateComment] avgScore : {}", avgScore);
	}


	/**
	 * 코멘트 수정
	 *
	 * @param commentId
	 * @param commentRequestDto
	 */
	public void modifyComment(Long userId, Long commentId, CommentRequestDto commentRequestDto) {
		CommentEntity comment = commentRepository.findById(commentId).orElseThrow(() -> new CustomException(ErrorCode.NOTFOUND_RESOURCE));
		// 본인이 맞는지 확인
		if (comment.getUserId().equals(userId) == false) {
			throw new CustomException(ErrorCode.INVALID_REQUEST);
		}
		// 수정
		comment.updateContent(commentRequestDto.getContent());
		comment.updateScore(commentRequestDto.getScore().floatValue());
		commentRepository.save(comment);

		// 도서 평균 점수 반영
		String bookId = comment.getBookId();
		float avgScore = commentRepository.findAvgScoreByBookId(bookId);
		bookClient.updateAverageScore(bookId, avgScore);
		log.info("[UpdateComment] avgScore : {}", avgScore);
	}


	/**
	 * 코멘트 삭제
	 *
	 * @param commentId
	 */
	public void deleteComment(Long userId, Long commentId) {
		CommentEntity comment = commentRepository.findById(commentId).orElseThrow(() -> new CustomException(ErrorCode.NOTFOUND_RESOURCE));
		// 본인이 맞는지 확인
		if (comment.getUserId().equals(userId) == false) {
			throw new CustomException(ErrorCode.INVALID_REQUEST);
		}
		// 삭제
		commentRepository.deleteById(commentId);

		// 도서 평균 점수 반영
		String bookId = comment.getBookId();
		float avgScore = commentRepository.findAvgScoreByBookId(bookId);
		bookClient.updateAverageScore(bookId, avgScore);
		log.info("[DeleteComment] avgScore : {}", avgScore);
	}


	/**
	 * 코멘트 3개 조회
	 *
	 * @param bookId
	 * @return
	 */
	public List<CommentResponseDto> get3Comment(String bookId) {
		List<CommentEntity> commentTop3 = commentRepository.findTop3ByBookIdOrderByCreatedAtDesc(bookId);

		// 각 comment의 writer id를 list로 생성
		List<Long> writerIdList = commentTop3.stream().map(c -> c.getUserId()).collect(Collectors.toList());
		List<CommentResponseDto> commentResponseDtoList;

		// writer 정보 조회, writer의 정보를 comment와 연결, commentResponseDto로 매핑
		try {
			List<UserSimpleInfoDto> writerInfoList = userClient.getUserSimpleInfo(writerIdList);
			AtomicInteger counter = new AtomicInteger(0); // map()에서 index 역할
			commentResponseDtoList = commentTop3.stream().map(
				c -> {
					int idx = counter.getAndIncrement();
					return createCommentResponseDto(c, writerInfoList.get(idx));
				}
			).collect(Collectors.toList());
		} catch (FeignException e) {
			log.error(e.getMessage());
			// 조회 실패한 경우, 빈 값은 default value로 채움
			commentResponseDtoList = commentTop3.stream().map(c -> createCommentResponseDto(c)).collect(Collectors.toList());
		}
		return commentResponseDtoList;
	}

}
