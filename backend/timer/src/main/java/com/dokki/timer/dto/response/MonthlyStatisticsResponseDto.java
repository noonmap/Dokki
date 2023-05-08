package com.dokki.timer.dto.response;


import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;


@Getter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class MonthlyStatisticsResponseDto {

	private int month;
	private int count;

}
