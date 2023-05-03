package com.dokki.book.dto.response;


import com.dokki.book.entity.BookEntity;
import com.dokki.book.entity.BookStatusEntity;
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
	private String bookTitle;
	private Integer accumReadTime;


	public static BookTimerResponseDto fromEntity(BookStatusEntity bookStatusEntity) {
		// TODO : 채우기 및 파라미터 수정 (accumReadTime 정보 있는 파라미터 추가)
		BookEntity book = bookStatusEntity.getBookId();
		return BookTimerResponseDto.builder()
			.bookId(book.getId())
			.bookTitle(book.getTitle())
			.accumReadTime(0)
			.build();
	}


	public static Slice<BookTimerResponseDto> fromEntitySlice(Slice<BookStatusEntity> bookEntityPage) {
		return bookEntityPage.map(BookTimerResponseDto::fromEntity);
	}

	public static BookTimerResponseDto fromStatusAndTimerEntity(BookStatusEntity bookStatusEntity, int time) {
		// TODO : 채우기 및 파라미터 수정 (accumReadTime 정보 있는 파라미터 추가)
		BookEntity book = bookStatusEntity.getBookId();
		return BookTimerResponseDto.builder()
			.bookId(book.getId())
			.bookTitle(book.getTitle())
			.accumReadTime(time)
			.build();
	}


	public static Slice<BookTimerResponseDto> fromStatusAndTimerEntitySlice(Slice<BookStatusEntity> bookStatusEntitySlice, List<TimerSimpleResponseDto> timeList) {
		// 정렬
		Collections.sort(bookStatusEntitySlice.getContent(), (c1, c2) -> Math.toIntExact(c2.getId() - c1.getId()));
		Collections.sort(timeList, (c1, c2) -> Math.toIntExact(c2.getBookStatusId() - c1.getBookStatusId()));
		
		// book status 정보와 time 맵핑
		AtomicInteger counter = new AtomicInteger(0); // map()에서 index 역할
		return bookStatusEntitySlice.map(
			c -> {
				int idx = counter.getAndIncrement();
				return BookTimerResponseDto.fromStatusAndTimerEntity(c, timeList.get(idx).getAccumTime());
			}
		);
	}

}
