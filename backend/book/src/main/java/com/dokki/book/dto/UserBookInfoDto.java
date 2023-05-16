package com.dokki.book.dto;


import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;


@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class UserBookInfoDto {

	private String bookId;
	private boolean isBookMarked;
	private boolean isReading;
	private boolean isComplete;

}
