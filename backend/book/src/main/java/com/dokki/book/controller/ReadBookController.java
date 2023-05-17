package com.dokki.book.controller;


import com.dokki.book.config.exception.CustomException;
import com.dokki.book.dto.response.BookTimerResponseDto;
import com.dokki.book.entity.BookStatusEntity;
import com.dokki.book.service.BookStatusService;
import com.dokki.book.service.BookTimerService;
import com.dokki.util.common.error.ErrorCode;
import com.dokki.util.common.utils.SessionUtils;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Slice;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;


@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/books/read-book")
@Api(tags = "[타이머 뷰] 읽고 있는 도서 API")
public class ReadBookController {

	private final BookTimerService bookTimerService;
	private final BookStatusService bookStatusService;


	@GetMapping("")
	@ApiOperation(value = "[타이머 뷰] 읽고 있는 도서 목록 조회")
	public ResponseEntity<Slice<BookTimerResponseDto>> getBookTimerList(Pageable pageable) {
		Long userId = SessionUtils.getUserId();
		Slice<BookTimerResponseDto> bookTimerSlice = bookTimerService.getBookTimerList(userId, pageable);
		return ResponseEntity.ok(bookTimerSlice);
	}


	@DeleteMapping("/{bookStatusId}")
	@ApiOperation(value = "[타이머 뷰] 읽고 있는 도서 삭제", notes = "")
	public ResponseEntity<HttpStatus> deleteBookTimer(@PathVariable Long bookStatusId) {
		Long userId = SessionUtils.getUserId();
		bookStatusService.deleteStatus(userId, bookStatusId);
		return new ResponseEntity<>(HttpStatus.OK);
	}


	@GetMapping("/simple/{bookId}")
	@ApiOperation(value = "(userId + bookId 조합으로 bookStatusId를 조회)")
	public ResponseEntity<Map<String, Long>> getBookStatusId(@PathVariable String bookId) {
		Long userId = SessionUtils.getUserId();
		HashMap<String, Long> map = new HashMap<>();
		BookStatusEntity entity = bookStatusService.getStatusByUserIdAndBookId(userId, bookId);
		if (entity == null) {
			throw new CustomException(ErrorCode.NOTFOUND_RESOURCE);
		}

		map.put("bookStatusId", entity.getId());
		return ResponseEntity.ok(map);
	}


	@GetMapping("/{bookStatusId}")
	@ApiOperation(value = "bookStatusId로 책 id 가져오기", notes = "")
	public ResponseEntity<String> getBookTimerId(@PathVariable Long bookStatusId) {
		BookStatusEntity bookStatusEntity = bookStatusService.getBookStatus(bookStatusId);
		return ResponseEntity.ok(bookStatusEntity.getBookId().getId());
	}

}
