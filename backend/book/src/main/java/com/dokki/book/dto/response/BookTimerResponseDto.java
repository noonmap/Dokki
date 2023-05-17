package com.dokki.book.dto.response;


import com.dokki.book.entity.BookEntity;
import com.dokki.book.entity.BookStatusEntity;
import com.dokki.util.common.utils.FileUtils;
import com.dokki.util.timer.dto.response.TimerSimpleResponseDto;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.springframework.data.domain.Slice;

import java.util.Collections;
import java.util.List;
import java.util.concurrent.atomic.AtomicInteger;


@Getter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class BookTimerResponseDto {

	private String bookId;
	private Long bookStatusId;
	private String bookTitle;
	private Integer accumReadTime;
	private String bookCoverPath;
	private String bookCoverBackImagePath;
	private String bookCoverSideImagePath;


	public static Slice<BookTimerResponseDto> fromEntitySlice(Slice<BookStatusEntity> bookEntityPage) {
		return bookEntityPage.map(o -> fromEntityandAccumTime(o, 0));
	}


	public static BookTimerResponseDto fromEntityandAccumTime(BookStatusEntity bookStatusEntity, int accumTime) {
		BookEntity book = bookStatusEntity.getBookId();
		return BookTimerResponseDto.builder()
			.bookId(book.getId())
			.bookStatusId(bookStatusEntity.getId())
			.bookTitle(book.getTitle())
			.accumReadTime(accumTime)
			.bookCoverPath(FileUtils.getAbsoluteFilePath(book.getCoverFrontImagePath()))
			.bookCoverBackImagePath(FileUtils.getAbsoluteFilePath(book.getCoverBackImagePath()))
			.bookCoverSideImagePath(FileUtils.getAbsoluteFilePath(book.getCoverSideImagePath()))
			.build();
	}


	public static Slice<BookTimerResponseDto> fromStatusEntityAndTimeListSlice(Slice<BookStatusEntity> bookStatusEntitySlice, List<TimerSimpleResponseDto> timeList) {
		// 정렬
		Collections.sort(timeList, (c1, c2) -> Math.toIntExact(c1.getBookStatusId() - c2.getBookStatusId()));

		// book status 정보와 time 맵핑
		AtomicInteger counter = new AtomicInteger(0); // map()에서 index 역할
		return bookStatusEntitySlice.map(
			c -> {
				int idx = counter.getAndIncrement();
				int accumTime = 0;
				if (idx < timeList.size()) {   // index 넘지 않을 경우
					if (!c.getId().equals(timeList.get(idx).getBookStatusId())) { // book status id don't match
						counter.decrementAndGet();
					} else {
						accumTime = timeList.get(idx).getAccumTime();
					}
				}
				return BookTimerResponseDto.fromEntityandAccumTime(c, accumTime);
			}
		);
	}

}
