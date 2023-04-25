package com.dokki.book.dto.response;


import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;


@Getter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class DailyStatisticsResponseDto {

	private Integer day;
	private String bookId;
	private String bookTitle;
	private String bookCoverPath;

}
