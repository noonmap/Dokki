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
@Table(name = "timer")
public class TimerEntity {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Long id;
	@Column(nullable = false)
	private Long userId;
	@Column(length = 20)
	private String bookId;
	@Column(nullable = false)
	private Long bookStatusId;
	@Column(nullable = false)
	private Integer accumTime;
	@Column(nullable = false)
	private LocalDate startTime;
	@Column(nullable = false)
	private LocalDate endTime;


	public void updateTimerStop(int currTime, LocalDate endTime) {
		this.accumTime += currTime;
		this.endTime = endTime;
	}


	public void updateBookComplete(LocalDate endTime) {
		this.endTime = endTime;
	}


	public void setStartTime(LocalDate startTime) {
		this.startTime = startTime;
	}


	public void setEndTime(LocalDate endTime) {
		this.endTime = endTime;
	}

}
