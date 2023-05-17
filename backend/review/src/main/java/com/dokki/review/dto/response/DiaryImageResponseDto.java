package com.dokki.review.dto.response;


import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;


@Getter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class DiaryImageResponseDto {

	private String diaryImagePath;
	private Integer count;

}
