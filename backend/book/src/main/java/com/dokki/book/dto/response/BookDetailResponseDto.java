package com.dokki.book.dto.response;


import com.dokki.book.entity.BookEntity;
import com.dokki.book.entity.BookStatisticsEntity;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.util.List;


@Getter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class BookDetailResponseDto {

	private String bookId;
	private String bookTitle;
	private String bookAuthor;
	private String bookCoverPath;
	private String bookPublishYear;
	private String bookPublisher;
	private Integer bookTotalPage;

	private List<ReviewResponseDto> review;
	private Integer readerCount;    // 읽은 사람
	private Float meanScore;
	private Integer meanReadTime;


	public static BookDetailResponseDto fromEntity(BookEntity item) {
		String year = Integer.toString(item.getPublishDate().getYear());    // date to year (string)
		BookDetailResponseDto responseDto = BookDetailResponseDto.builder()
			.bookId(item.getId())
			.bookTitle(item.getTitle())
			.bookAuthor(item.getAuthor())
			.bookCoverPath(item.getCoverImagePath())
			.bookPublishYear(year)
			.bookPublisher(item.getPublisher())
			.bookTotalPage(item.getTotalPageCount())
			.build();

		// 통계결과 있을 경우
		if (item.getStatistics() != null) {
			BookStatisticsEntity statistics = item.getStatistics();
			responseDto.readerCount = statistics.getCompletedUsers();
			responseDto.meanScore = statistics.getMeanScore();
			responseDto.meanReadTime = statistics.getMeanReadTime();
		}
		return responseDto;
	}

}
