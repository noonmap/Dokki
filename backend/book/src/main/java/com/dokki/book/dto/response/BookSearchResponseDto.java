package com.dokki.book.dto.response;


import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.springframework.data.domain.Page;

import java.util.List;


@Getter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class BookSearchResponseDto {

	private String bookId;
	private String bookTitle;
	private String bookAuthor;
	private String bookCoverPath;
	private String bookPublishYear;


	public static Page<BookSearchResponseDto> toPagefromApiResponse(List<Object> apiResult) {
		// TODO: 구현 및 파라미터 수정
		return null;
	}

}
