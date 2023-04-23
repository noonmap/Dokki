package com.dokki.book.controller;


import com.dokki.book.dto.response.DailyStatisticsResponse;
import com.dokki.book.service.HistoryService;
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


	@GetMapping("/{userId}")
	@ApiOperation(value = "도서의 리뷰(코멘트) 목록 조회")
	public ResponseEntity<Integer[]> getYearHistory(@PathVariable Long userId, @RequestParam int year, @RequestParam int month) {
		Integer[] yearHistory = historyService.getYearHistory(userId, year);
		return ResponseEntity.ok(yearHistory);
	}


	@GetMapping("/{userId}")
	@ApiOperation(value = "도서의 리뷰(코멘트) 목록 조회")
	public ResponseEntity<List<DailyStatisticsResponse>> getMonthHistory(@PathVariable Long userId, @RequestParam int year, @RequestParam int month) {
		List<DailyStatisticsResponse> dailyStatisticsList = historyService.getDailyStatisticsList(userId, year, month);
		return ResponseEntity.ok(dailyStatisticsList);
	}

}
