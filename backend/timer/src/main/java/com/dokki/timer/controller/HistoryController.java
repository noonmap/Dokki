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

import java.util.HashMap;
import java.util.List;
import java.util.Map;


@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/timers/history")
@Api(tags = "히스토리 API")
public class HistoryController {

	private final HistoryService historyService;


	@GetMapping("/today/{userId}")
	@ApiOperation(value = "오늘 독서 시간 조회", notes = "유저의 오늘 총 독서시간을 조회합니다")
	public ResponseEntity<Map<String, Integer>> getTodayReadTime(@PathVariable Long userId) {
		int time = historyService.getTodayReadTime(userId);
		Map<String, Integer> result = new HashMap<>();
		result.put("todayTime", time);
		return ResponseEntity.ok(result);
	}


	@GetMapping("/year/{userId}")
	@ApiOperation(value = "한 해 독서 시간 조회", notes = "프로필에서 사용, Integer[12]")
	public ResponseEntity<List<MonthlyStatisticsResponseDto>> getYearHistory(@PathVariable Long userId, @RequestParam int year) {
		return ResponseEntity.ok(historyService.getYearHistory(userId, year));
	}


	@GetMapping("/month/{userId}")
	@ApiOperation(value = "한 달 독서 기록 조회", notes = "프로필에서 사용, 달력 형태")
	public ResponseEntity<List<DailyStatisticsResponseDto>> getMonthHistory(@PathVariable Long userId, @RequestParam int year, @RequestParam int month) {
		return ResponseEntity.ok(historyService.getDailyStatisticsList(userId, year, month));
	}

}
