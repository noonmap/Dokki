package com.dokki.timer.dto.response;


import com.dokki.timer.entity.DailyStatisticsEntity;
import com.dokki.util.book.dto.response.BookSimpleResponseDto;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.time.LocalDate;
import java.util.List;
import java.util.stream.Collectors;


@Getter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class DailyStatisticsResponseDto {

	private Integer day;
	private Integer dayOfWeek;
	private String bookId;
	private String bookTitle;
	private String bookCoverPath;


	public static DailyStatisticsResponseDto fromEntity(DailyStatisticsEntity entity, BookSimpleResponseDto bookDto) {
		LocalDate date = entity.getRecordDate();
		int dayOfWeek = date.getDayOfWeek().getValue();
		dayOfWeek = dayOfWeek != 7 ? dayOfWeek : 0; // 0~6 (일~금)
		return DailyStatisticsResponseDto.builder()
			.day(date.getDayOfMonth())
			.dayOfWeek(dayOfWeek)
			.bookId(entity.getBookId())
			.bookTitle(bookDto.getBookTitle())
			.bookCoverPath(bookDto.getBookCoverPath())
			.build();
	}


	public static List<DailyStatisticsResponseDto> fromEntityList(List<DailyStatisticsEntity> dailyStatisticsEntity, List<BookSimpleResponseDto> bookList) {
		return dailyStatisticsEntity.stream().map(o -> {
			// 책 정보 찾기, 없으면 빈값으로
			BookSimpleResponseDto book = bookList.stream()
				.filter(b -> o.getBookId().equals(b.getBookId()))
				.findAny()
				.orElse(BookSimpleResponseDto.builder()
					.bookTitle(" ")
					.bookCoverPath(" ")
					.build());
			return fromEntity(o, book);
		}).collect(Collectors.toList());
	}

}
