package com.dokki.book.dto.response;


import com.dokki.book.entity.BookEntity;
import com.dokki.book.entity.BookStatusEntity;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.springframework.data.domain.Slice;


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
			.build();
	}


	public static Slice<BookTimerResponseDto> fromEntitySlice(Slice<BookStatusEntity> bookEntityPage) {
		return bookEntityPage.map(BookTimerResponseDto::fromEntity);
	}

}
