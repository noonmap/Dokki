package com.dokki.book.dto.request;


import lombok.Getter;
import lombok.Setter;

import java.time.LocalDate;


@Getter
@Setter
public class BookCompleteRequestDto {

	private String bookId;
	private LocalDate startTime;
	private LocalDate endTime;

}
