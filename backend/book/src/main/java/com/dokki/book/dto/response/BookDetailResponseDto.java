package com.dokki.book.dto.response;


import com.dokki.book.entity.BookEntity;
import com.dokki.book.entity.BookStatisticsEntity;

import java.util.List;


public class BookDetailResponseDto {

	private List<ReviewResponseDto> review;
	private Integer readerCount;
	private Integer meanScore;
	private Integer meanReadTime;


	public static BookDetailResponseDto fromEntity(BookEntity bookEntity, BookStatisticsEntity statisticsEntity) {
		// TODO : 채우기
		return new BookDetailResponseDto();
	}

}
