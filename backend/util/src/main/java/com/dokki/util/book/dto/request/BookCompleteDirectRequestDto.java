package com.dokki.util.book.dto.request;


import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.time.LocalDate;


@Getter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class BookCompleteDirectRequestDto {

	private String bookId;
	private Long bookStatusId;
	private LocalDate startTime;
	private LocalDate endTime;

}