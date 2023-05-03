package com.dokki.timer.controller;


import com.dokki.timer.service.TimerService;
import com.dokki.util.timer.dto.response.TimerSimpleResponseDto;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;


@Log4j2
@RestController
@RequestMapping("/timers")
@RequiredArgsConstructor
@Api(tags = "독서 타이머 관련 API")
public class TimerController {

	private final TimerService timerService;


	@PostMapping("/{bookId}/start")
	@ApiOperation(value = "독서 시간 측정을 시작합니다.")
	public ResponseEntity<Boolean> startTimer(@PathVariable String bookId) {
		timerService.startTimer(bookId);
		return ResponseEntity.ok(true);
	}


	@PostMapping("/{bookId}/end")
	@ApiOperation(value = "독서 시간 측정을 종료합니다.", notes = "시작 시간과 종료 시간을 저장하고, 두 시간의 차를 독서 누적 시간에 추가합니다.")
	public ResponseEntity<Boolean> endTimer(@PathVariable String bookId) {
		timerService.endTimer(bookId);
		return ResponseEntity.ok(true);
	}


	@GetMapping("/history/{userId}")
	@ApiOperation(value = "한 달 독서 기록을 조회합니다. (프로필에서 사용, 달력 형태)", notes = "하루 중 가장 읽은 시간이 긴 책 리스트를 반환합니다. 리스트 요소의 형태는 {day: Integer, bookId: String}와 같습니다.")
	public ResponseEntity<List<Map<String, String>>> getMonthlyReadTimeHistory(@PathVariable Long userId, @RequestParam("year") Integer year, @RequestParam Integer month) {
		List<Map<String, String>> result = timerService.getMonthlyReadTimeHistory(userId, year, month);
		return ResponseEntity.ok(result);
	}


	@DeleteMapping("/{userId}/{bookId}")
	@ApiOperation(value = "타이머 정보를 삭제합니다.")
	public ResponseEntity<Boolean> deleteTimer(@PathVariable Integer userId, @PathVariable String bookId) {
		timerService.deleteTimer(userId, bookId);
		return ResponseEntity.ok(true);
	}


	@PostMapping
	@ApiOperation(value = "타이머 정보 중 누적 시간을 조회합니다.", notes = "조회하고 싶은 도서의 book_status_id를 리스트로 Request에 담아 요청합니다. 타이머 뷰에서 이용합니다.")
	public ResponseEntity<List<TimerSimpleResponseDto>> getAccumTime(@RequestBody List<Long> bookStatusIdList) {
		List<TimerSimpleResponseDto> result = timerService.getAccumTimeList(bookStatusIdList);
		return ResponseEntity.ok(result);
	}


	@PutMapping("/{bookStatusId}/endtime")
	@ApiOperation(value = "독서 완독 시간 정보를 추가 또는 삭제(null)합니다.", notes = "도서 상태 변경할 때 이용합니다.")
	public ResponseEntity<Boolean> modifyEndTime(@PathVariable Long bookStatusId, @RequestParam Boolean done) {
		timerService.modifyEndTime(bookStatusId, done);
		return ResponseEntity.ok(true);
	}

}
