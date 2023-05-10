package com.dokki.timer.dto.response;


import lombok.*;

import javax.persistence.Column;
import java.util.Objects;


@ToString
@Getter
@Setter
@NoArgsConstructor
public class MonthlyStatisticsResponseDto {
//	@Column(name = "type_name")
	private Integer month;
//	@Column(name = "type_name")
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
