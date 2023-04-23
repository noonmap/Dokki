package com.dokki.book.controller;


import com.dokki.book.dto.response.BookDetailResponseDto;
import com.dokki.book.service.BookService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;


@Log4j2
@RestController
@RequiredArgsConstructor
@RequestMapping("/books")
@Api(tags = "책 API")
public class BookController {

	public BookService bookService;


	@GetMapping("/{bookId}")
	@ApiOperation(value = "도서 상세 조회")
	public ResponseEntity<BookDetailResponseDto> getBook(@PathVariable String bookId) {
		BookDetailResponseDto bookDetail = bookService.getBook(bookId);
		return ResponseEntity.ok(bookDetail);
	}

}
