package com.dokki.timer.dto.response;


import lombok.*;


@Getter
@Setter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class MonthlyStatisticsResponseDto {

	private int month;
	private int count;

}
