package com.dokki.review.dto.response;


import com.dokki.review.entity.DiaryEntity;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.format.annotation.DateTimeFormat;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Getter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class DiaryResponseDto {

	private String bookId;
	private String bookTitle;
	private String diaryImagePath;
	private String diaryContent;
	@DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME)
	private LocalDateTime created;


	public static DiaryResponseDto fromEntity(DiaryEntity diaryEntity) {
		// TODO : 채우기
		return new DiaryResponseDto();
	}


	public static Page<DiaryResponseDto> fromEntityPage(Page<DiaryEntity> diaryEntityPage) {
		return diaryEntityPage.map(DiaryResponseDto::fromEntity);
	}

}
