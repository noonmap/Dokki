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
public class CollectionResponseDto {

	private Long bookStatusId;
	private String bookId;
	private String bookTitle;
	private String bookCoverPath;  // 책 표지


	public static CollectionResponseDto fromEntity(BookStatusEntity entity) {
		BookEntity book = entity.getBookId();
		return CollectionResponseDto.builder()
			.bookStatusId(entity.getId())
			.bookId(book.getId())
			.bookTitle(book.getTitle())
			.bookCoverPath(book.getCoverFrontImagePath())
			.build();
	}


	public static Slice<CollectionResponseDto> fromEntitySlice(Slice<BookStatusEntity> bookEntitySlice) {
		return bookEntitySlice.map(CollectionResponseDto::fromEntity);
	}

}
