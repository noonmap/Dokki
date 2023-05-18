package com.dokki.util.timer.dto.response;


import lombok.*;


@ToString
@Getter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class TimerSimpleResponseDto {

	private Long bookStatusId;
	private Integer accumTime;

}
