package com.dokki.book.dto.response;


import com.dokki.book.entity.BookStatusEntity;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.springframework.data.domain.Page;


@Getter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class CollectionResponseDto {

	private String bookId;
	private String bookTitle;
	private String diaryImagePath;  // 감정일기 경로


	public static CollectionResponseDto fromEntity(BookStatusEntity bookStatusEntity) {
		// TODO : 채우기
		return new CollectionResponseDto();
	}


	public static Page<CollectionResponseDto> fromEntityPage(Page<BookStatusEntity> bookEntityPage) {
		return bookEntityPage.map(CollectionResponseDto::fromEntity);
	}

}
