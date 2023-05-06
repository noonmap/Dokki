package com.dokki.util.timer.dto.response;


import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;


@Getter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class TimerSimpleResponseDto {

	private Long bookStatusId;
	private Integer accumTime;

}
