package com.dokki.timer.service;


import com.dokki.timer.repository.DailyStatisticsRepository;
import com.dokki.timer.repository.TimerRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import org.springframework.stereotype.Service;


@Log4j2
@Service
@RequiredArgsConstructor
public class TimerService {

	private final TimerRepository timerRepository;
	private final DailyStatisticsRepository dailyStatisticsRepository;


	/**
	 * 독서 시간 측정 시작
	 *
	 * @param bookId
	 */
	public void startTimer(String bookId) {
	}


	/**
	 * 독서 시간 측정 종료
	 *
	 * @param bookId
	 */
	public void endTimer(String bookId) {
	}

}
