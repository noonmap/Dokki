package com.dokki.timer.controller;


import com.dokki.timer.service.TimerService;
import com.dokki.util.book.dto.request.BookCompleteDirectRequestDto;
import com.dokki.util.common.utils.SessionUtils;
import com.dokki.util.timer.dto.response.TimerResponseDto;
import com.dokki.util.timer.dto.response.TimerSimpleResponseDto;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;


@Log4j2
@RestController
@RequestMapping("/timers")
@RequiredArgsConstructor
@Api(tags = "독서 타이머 관련 API")
public class TimerController {

	private final TimerService timerService;


	@GetMapping("/{bookStatusId}")
	@ApiOperation(value = "bookStatusId로 타이머 정보 조회")
	public ResponseEntity<TimerResponseDto> getTimerByBookStatusId(@PathVariable Long bookStatusId) {
		Long userId = SessionUtils.getUserId();
		return ResponseEntity.ok(timerService.getTimerByBookStatusId(userId, bookStatusId));
	}


	@PostMapping("/{bookStatusId}/start")
	@ApiOperation(value = "독서 시간 측정을 시작합니다.")
	public ResponseEntity<Boolean> startTimer(@PathVariable Long bookStatusId) {
		Long userId = SessionUtils.getUserId();
		timerService.startTimer(userId, bookStatusId);
		return ResponseEntity.ok(null);
	}


	@PostMapping("/{bookStatusId}/end")
	@ApiOperation(value = "독서 시간 측정을 종료합니다.", notes = "시작 시간과 종료 시간을 저장하고, 두 시간의 차를 독서 누적 시간에 추가합니다.")
	public ResponseEntity<Boolean> endTimer(@PathVariable Long bookStatusId) {
		Long userId = SessionUtils.getUserId();
		timerService.endTimer(bookStatusId, userId);
		return ResponseEntity.ok(null);
	}


	@DeleteMapping("/{bookStatusId}")
	@ApiOperation(value = "타이머 정보를 삭제합니다.")
	public ResponseEntity<Boolean> deleteTimer(@PathVariable Long bookStatusId) {
		Long userId = SessionUtils.getUserId();
		timerService.deleteTimer(userId, bookStatusId);
		return ResponseEntity.ok(null);
	}


	@PutMapping("/{bookStatusId}/complete")
	@ApiOperation(value = "독서 완독 시간 수정", notes = "도서 상태 변경할 때 이용합니다.")
	public ResponseEntity<Boolean> modifyEndTime(@PathVariable Long bookStatusId) {
		Long userId = SessionUtils.getUserId();
		timerService.modifyEndTime(userId, bookStatusId);
		return ResponseEntity.ok(null);
	}


	@GetMapping("/{bookStatusId}/reset")
	@ApiOperation(value = "타이머 누적 시간 초기화", notes = "다 읽은 책을 다시 읽을 경우 초기화")
	public ResponseEntity<Boolean> resetAccumTime(@PathVariable Long bookStatusId) {
		Long userId = SessionUtils.getUserId();
		timerService.resetAccumTime(userId, bookStatusId);
		return ResponseEntity.ok(null);
	}


	@PostMapping("/accum")
	@ApiOperation(value = "타이머 정보 중 누적 시간을 조회합니다.", notes = "조회하고 싶은 도서의 book_status_id를 리스트로 Request에 담아 요청합니다. 타이머 뷰에서 이용합니다.")
	public ResponseEntity<List<TimerSimpleResponseDto>> getAccumTime(@RequestBody List<Long> bookStatusIdList) {
		Long userId = SessionUtils.getUserId();
		List<TimerSimpleResponseDto> result = timerService.getAccumTimeList(userId, bookStatusIdList);
		return ResponseEntity.ok(result);
	}


	@PostMapping("/direct-complete")
	@ApiOperation(value = "[내부호출] 날짜, bookId, bookStatusId 로 타이머 테이블에 추가 또는 update")
	public ResponseEntity<Boolean> startTimer(@RequestBody BookCompleteDirectRequestDto request) {
		Long userId = SessionUtils.getUserId();
		timerService.createTimerDirect(userId, request);
		return ResponseEntity.ok(null);
	}

}
