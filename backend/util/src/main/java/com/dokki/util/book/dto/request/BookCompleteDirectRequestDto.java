package com.dokki.util.book.dto.request;

import lombok.Getter;
import lombok.Setter;

import java.time.LocalDate;


@Getter
@Setter
public class BookCompleteDirectRequestDto {

	private String bookId;
	private LocalDate startTime;
	private LocalDate endTime;

}