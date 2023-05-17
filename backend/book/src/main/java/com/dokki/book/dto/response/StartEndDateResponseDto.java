package com.dokki.book.dto.response;


import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.time.LocalDate;


@Getter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class StartEndDateResponseDto {

	private LocalDate startTime;
	private LocalDate endTime;

}
