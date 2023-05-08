package com.dokki.timer.entity;


import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import javax.persistence.*;
import java.time.LocalDate;


@Entity
@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Table(name = "daily_statisics")
public class DailyStatisticsEntity {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Long id;
	@Column(nullable = false)
	private Long userId;
	@Column(nullable = false, length = 20)
	private String bookId;
	@Column(nullable = false)
	private Integer accumTime;
	@Column(nullable = false)
	private LocalDate recordDate;

	public void updateTimerStop(int currTime) {
		this.accumTime += currTime;
	}

}
