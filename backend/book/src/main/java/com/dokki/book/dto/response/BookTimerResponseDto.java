package com.dokki.book.dto.response;


public class BookTimerResponseDto {

	private String bookId;
	private String bookTitle;
	private Integer accumReadTime;

	//	public static BookTimerResponseDto fromEntity(BookEntity bookEntity) {
	//		// TODO : 채우기 및 파라미터 수정 (accumReadTime 정보 있는 파라미터 추가)
	//		return new BookTimerResponseDto();
	//	}
	//
	//
	//	public static Page<BookTimerResponseDto> fromEntityPage(Page<BookEntity> bookEntityPage) {
	//		return bookEntityPage.map(BookTimerResponseDto::fromEntity);
	//	}

}
