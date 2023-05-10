package com.dokki.book.dto.response;


import com.dokki.book.dto.UserBookInfoDto;
import com.dokki.book.entity.BookEntity;
import com.dokki.book.entity.BookStatisticsEntity;
import com.dokki.util.common.utils.FileUtils;
import com.dokki.util.review.dto.response.CommentResponseDto;
import com.fasterxml.jackson.annotation.JsonProperty;
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
	private String bookSummary;
	private String bookAuthor;
	private String bookLink;
	private String bookCoverPath;
	private String bookCoverBackImagePath;
	private String bookCoverSideImagePath;
	private String bookPublishYear;
	private String bookPublisher;
	private Integer bookTotalPage;

	private List<CommentResponseDto> review;
	private Integer readerCount;    // 읽은 사람
	private Float meanScore;
	private Integer meanReadTime;

	@JsonProperty("isBookMarked")
	private Boolean isBookMarked;
	@JsonProperty("isReading")
	private Boolean isReading;
	@JsonProperty("isComplete")
	private Boolean isComplete;


	public static BookDetailResponseDto fromEntity(BookEntity item) {
		String year = Integer.toString(item.getPublishDate().getYear());    // date to year (string)
		BookDetailResponseDto responseDto = BookDetailResponseDto.builder()
			.bookId(item.getId())
			.bookTitle(item.getTitle())
			.bookSummary(item.getSummary())
			.bookAuthor(item.getAuthor())
			.bookLink(item.getLink())
			.bookCoverPath(FileUtils.getAbsoluteFilePath(item.getCoverFrontImagePath()))
			.bookCoverBackImagePath(FileUtils.getAbsoluteFilePath(item.getCoverBackImagePath()))
			.bookCoverSideImagePath(FileUtils.getAbsoluteFilePath(item.getCoverSideImagePath()))
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


	public void setReview(List<CommentResponseDto> review) {
		this.review = review;
	}


	public void setUserData(UserBookInfoDto userData) {
		this.isBookMarked = userData.isBookMarked();
		this.isReading = userData.isReading();
		this.isComplete = userData.isComplete();
	}

}
