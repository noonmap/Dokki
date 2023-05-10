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

	private Long bookStatusId;
	private String bookTitle;
	private Integer accumReadTime;


	public static BookTimerResponseDto fromEntity(BookStatusEntity bookStatusEntity) {
		// TODO : 채우기 및 파라미터 수정 (accumReadTime 정보 있는 파라미터 추가)
		BookEntity book = bookStatusEntity.getBookId();
		return BookTimerResponseDto.builder()
			.bookStatusId(bookStatusEntity.getId())
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
			.bookStatusId(bookStatusEntity.getId())
			.bookTitle(book.getTitle())
			.accumReadTime(time)
			.build();
	}


	public static Slice<BookTimerResponseDto> fromStatusAndTimerEntitySlice(Slice<BookStatusEntity> bookStatusEntitySlice, List<TimerSimpleResponseDto> timeList) {
		// 정렬
		Collections.sort(timeList, (c1, c2) -> Math.toIntExact(c1.getBookStatusId() - c2.getBookStatusId()));

		// book status 정보와 time 맵핑
		AtomicInteger counter = new AtomicInteger(0); // map()에서 index 역할
		return bookStatusEntitySlice.map(
			c -> {
				int idx = counter.getAndIncrement();
				if (idx >= timeList.size()) {   // out of index
					return BookTimerResponseDto.fromEntity(c);
				} else if (!c.getId().equals(timeList.get(idx).getBookStatusId())) { // book status id don't match
					counter.decrementAndGet();
					return BookTimerResponseDto.fromEntity(c);
				} else {
					return BookTimerResponseDto.fromStatusAndTimerEntity(c, timeList.get(idx).getAccumTime());
				}
			}
		);
	}

}
