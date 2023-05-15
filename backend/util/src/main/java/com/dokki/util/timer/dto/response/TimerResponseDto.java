package com.dokki.util.timer.dto.response;


import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.time.LocalDate;


@Getter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class TimerResponseDto {

	private Long id;
	private Long bookStatusId;
	private Long userId;
	private String bookId;
	private Integer accumTime;
	private LocalDate startTime;
	private LocalDate endTime;

}
