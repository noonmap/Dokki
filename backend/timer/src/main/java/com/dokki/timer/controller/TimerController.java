package com.dokki.timer.controller;


import com.dokki.timer.service.TimerService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;


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

}
