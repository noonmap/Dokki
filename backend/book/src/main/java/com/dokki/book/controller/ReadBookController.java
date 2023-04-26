package com.dokki.book.controller;


import com.dokki.book.service.BookTimerService;
import com.dokki.book.dto.response.BookTimerResponseDto;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;


@Log4j2
@RestController
@RequiredArgsConstructor
@RequestMapping("/books/read-book")
@Api(tags = "[타이머 뷰] 읽고 있는 도서 API")
public class ReadBookController {

	private final BookTimerService bookTimerService;


	@GetMapping("")
	@ApiOperation(value = "[타이머 뷰] 읽고 있는 도서 목록 조회")
	public ResponseEntity<Page<BookTimerResponseDto>> getBookTimerList(@RequestParam Pageable pageable) {
		Long userId = 0L;   // TODO: userId 가져오기
		Page<BookTimerResponseDto> bookTimerPage = bookTimerService.getBookTimerList(userId, pageable);
		return ResponseEntity.ok(bookTimerPage);
	}


	@DeleteMapping("/{bookId}")
	@ApiOperation(value = "[타이머 뷰] 읽고 있는 도서 삭제", notes = "")
	public ResponseEntity<HttpStatus> deleteBookTimer(@PathVariable String bookId) {
		Long userId = 0L;   // TODO: userId 가져오기
		bookTimerService.deleteBookTimer(bookId, userId);
		return new ResponseEntity<>(HttpStatus.OK);
	}

}
