package com.dokki.util.review.dto.response;


import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.springframework.format.annotation.DateTimeFormat;

import java.time.LocalDateTime;


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

	@DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME)
	public LocalDateTime created;

}
