package com.dokki.timer.controller;


import com.dokki.timer.dto.response.DailyStatisticsResponseDto;
import com.dokki.timer.dto.response.MonthlyStatisticsResponseDto;
import com.dokki.timer.service.HistoryService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.List;


@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/timers/history")
@Api(tags = "히스토리 API")
public class HistoryController {

	private final HistoryService historyService;


	@GetMapping("/year/{userId}")
	@ApiOperation(value = "한 해 독서 시간 조회", notes = "프로필에서 사용, Integer[12]")
	public ResponseEntity<List<MonthlyStatisticsResponseDto>> getYearHistory(@PathVariable Long userId, @RequestParam int year) {
		Integer[] yearHistory = historyService.getYearHistory(userId, year);
		
		// 목업
		yearHistory = new Integer[] { 3, 1, 0, 0, 1, 1, 1, 1, 4, 3, 2, 1 };
		List<MonthlyStatisticsResponseDto> list = new ArrayList<>();
		for (int i = 0; i < 12; i++) {
			list.add(MonthlyStatisticsResponseDto.builder()
				.month(i + 1)
				.count(yearHistory[i])
				.build());
		}
		return ResponseEntity.ok(list);
	}


	@GetMapping("/month/{userId}")
	@ApiOperation(value = "한 달 독서 기록 조회", notes = "프로필에서 사용, 달력 형태")
	public ResponseEntity<List<DailyStatisticsResponseDto>> getMonthHistory(@PathVariable Long userId, @RequestParam int year, @RequestParam int month) {
		List<DailyStatisticsResponseDto> dailyStatisticsList = historyService.getDailyStatisticsList(userId, year, month);
		dailyStatisticsList = new ArrayList<>();
		dailyStatisticsList.add(DailyStatisticsResponseDto.builder()
			.day(1)
			.dayOfWeek(6)
			.bookId("9791197021688")
			.bookTitle("살인자의 기억법")
			.bookCoverPath("https://image.aladin.co.kr/product/24940/40/cover/k732632690_1.jpg")
			.build());
		dailyStatisticsList.add(DailyStatisticsResponseDto.builder()
			.day(10)
			.dayOfWeek(1)
			.bookId("9791192674339")
			.bookTitle("제2한강")
			.bookCoverPath("https://image.aladin.co.kr/product/30913/36/cover/k482831585_1.jpg")
			.build());
		dailyStatisticsList.add(DailyStatisticsResponseDto.builder()
			.day(14)
			.dayOfWeek(5)
			.bookId("9791192674339")
			.bookTitle("제2한강")
			.bookCoverPath("https://image.aladin.co.kr/product/30913/36/cover/k482831585_1.jpg")
			.build());
		dailyStatisticsList.add(DailyStatisticsResponseDto.builder()
			.day(19)
			.dayOfWeek(3)
			.bookId("8809895820067")
			.bookTitle("시나모롤 컬러링 아트북")
			.bookCoverPath("https://image.aladin.co.kr/product/31356/62/cover/k232832099_1.jpg")
			.build());
		return ResponseEntity.ok(dailyStatisticsList);
	}

}
