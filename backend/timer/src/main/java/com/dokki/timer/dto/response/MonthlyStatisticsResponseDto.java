package com.dokki.timer.dto.response;


import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

import java.util.Objects;


@ToString
@Getter
@Setter
@NoArgsConstructor
public class MonthlyStatisticsResponseDto {

	private Integer month;
	private Long count;


	public MonthlyStatisticsResponseDto(Integer month, Long count) {
		this.month = month;
		this.count = count;
	}


	@Override
	public boolean equals(Object o) {
		if (this == o) return true;
		if (o == null || getClass() != o.getClass()) return false;
		MonthlyStatisticsResponseDto that = (MonthlyStatisticsResponseDto) o;
		return month.equals(that.month) && count.equals(that.count);
	}


	@Override
	public int hashCode() {
		return Objects.hash(month, count);
	}

}
