package com.dokki.util.book.dto.response;


import lombok.AllArgsConstructor;
import lombok.NoArgsConstructor;

import java.time.LocalDate;


@NoArgsConstructor
@AllArgsConstructor
public class ReviewResponseDto {

	private Long userId;
	private String nickname;
	private String profileImagePath;
	private LocalDate created;
	private Integer score;
	private String review;

}
