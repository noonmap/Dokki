package com.dokki.util.book.dto.response;


import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;


@Getter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class BookSimpleResponseDto {

	private String bookId;
	private String bookTitle;
	private String bookCoverPath;
	private String bookAuthor;
	private String bookPublishYear;
	private String bookPublisher;
	
}
