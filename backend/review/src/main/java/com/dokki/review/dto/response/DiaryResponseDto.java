package com.dokki.review.dto.response;


import com.dokki.review.entity.DiaryEntity;
import org.springframework.data.domain.Page;

import java.time.LocalDate;


public class DiaryResponseDto {

	private String bookId;
	private String bookTitle;
	private String diaryImagePath;
	private String diaryContent;
	private LocalDate created;


	public static DiaryResponseDto fromEntity(DiaryEntity diaryEntity) {
		// TODO : 채우기
		return new DiaryResponseDto();
	}


	public static Page<DiaryResponseDto> fromEntityPage(Page<DiaryEntity> diaryEntityPage) {
		return diaryEntityPage.map(DiaryResponseDto::fromEntity);
	}

}
