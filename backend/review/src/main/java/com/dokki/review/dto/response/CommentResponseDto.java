package com.dokki.review.dto.response;


import com.dokki.review.entity.CommentEntity;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.format.annotation.DateTimeFormat;

import java.time.LocalDate;


@Getter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class CommentResponseDto {

	// user info
	public Long userId;
	public String nickname;
	public String profileImagePath;

	// comment info
	public Integer score;
	public String content;

	@DateTimeFormat(iso = DateTimeFormat.ISO.DATE)
	public LocalDate created;


	public static CommentResponseDto fromEntity(CommentEntity commentEntity) {
		// TODO: 채울 것
		return new CommentResponseDto();
	}


	public static Page<CommentResponseDto> fromEntityPage(Page<CommentEntity> commentEntityPage) {
		return commentEntityPage.map(CommentResponseDto::fromEntity);
	}

}
