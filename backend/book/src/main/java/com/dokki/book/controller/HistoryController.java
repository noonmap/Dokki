package com.dokki.book.controller;


import com.dokki.book.service.HistoryService;
import com.dokki.book.dto.response.DailyStatisticsResponseDto;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;


@Log4j2
@RestController
@RequiredArgsConstructor
@RequestMapping("/books/history")
@Api(tags = "히스토리 API")
public class HistoryController {

	public HistoryService historyService;


	@GetMapping("/time/{userId}")
	@ApiOperation(value = "한 해 독서 시간 조회", notes = "프로필에서 사용, Integer[12]")
	public ResponseEntity<Integer[]> getYearHistory(@PathVariable Long userId, @RequestParam int year) {
		Integer[] yearHistory = historyService.getYearHistory(userId, year);
		return ResponseEntity.ok(yearHistory);
	}


	@GetMapping("/{userId}")
	@ApiOperation(value = "한 달 독서 기록 조회", notes = "프로필에서 사용, 달력 형태")
	public ResponseEntity<List<DailyStatisticsResponseDto>> getMonthHistory(@PathVariable Long userId, @RequestParam int year, @RequestParam int month) {
		List<DailyStatisticsResponseDto> dailyStatisticsList = historyService.getDailyStatisticsList(userId, year, month);
		return ResponseEntity.ok(dailyStatisticsList);
	}

}
