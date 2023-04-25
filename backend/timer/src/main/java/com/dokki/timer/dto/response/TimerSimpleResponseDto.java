package com.dokki.timer.dto.response;


import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;


@Getter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class TimerSimpleResponseDto {

	private Long timerId;
	private String bookId;
	private Integer accumTime;

}
