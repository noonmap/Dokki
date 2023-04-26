package com.dokki.book.controller;


import com.dokki.book.dto.response.AladinItemResponseDto;
import com.dokki.book.dto.response.BookDetailResponseDto;
import com.dokki.book.dto.response.BookSearchResponseDto;
import com.dokki.book.entity.BookEntity;
import com.dokki.book.enums.SearchType;
import com.dokki.book.service.BookService;
import com.dokki.book.service.BookStatusService;
import com.dokki.book.service.BookmarkService;
import com.dokki.util.book.dto.response.BookSimpleResponseDto;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Slice;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.io.IOException;


@Log4j2
@RestController
@RequiredArgsConstructor
@RequestMapping("/books")
@Api(tags = "책 API")
public class BookController {

	private final BookService bookService;
	private final BookmarkService bookmarkService;
	private final BookStatusService bookStatusService;


	@GetMapping("/{bookId}")
	@ApiOperation(value = "도서 상세 조회")
	public ResponseEntity<BookDetailResponseDto> getBook(@PathVariable String bookId) {
		BookDetailResponseDto bookDetail = bookService.getBook(bookId);
		return ResponseEntity.ok(bookDetail);
	}


	@GetMapping("/search")
	@ApiOperation(value = "도서 검색")
	public ResponseEntity<Slice<BookSearchResponseDto>> searchBookList(@RequestParam String search, @RequestParam String queryType, Pageable pageable) throws IOException {
		Slice<AladinItemResponseDto> apiBookResponseDtoSlice = bookService.searchBookList(search, SearchType.findByName(queryType), pageable);
		Slice<BookSearchResponseDto> bookSearchResponseDtoSlice = BookSearchResponseDto.toSliceFromApiResponse(apiBookResponseDtoSlice);
		return ResponseEntity.ok(bookSearchResponseDtoSlice);
	}
	

	@GetMapping("/like")
	@ApiOperation(value = "찜한 책 조회")
	public ResponseEntity<Page<BookSimpleResponseDto>> getBookmarkListByUserId(Pageable pageable) {
		Long userId = 0L;   // TODO: user id 가져오기
		Page<BookEntity> bookEntityPage = bookmarkService.getBookmarkList(userId, pageable);

		//	public static BookSimpleResponseDto fromEntity(BookEntity bookEntity) {
		//		// TODO : 채우기
		//		return new BookSimpleResponseDto();
		//	}
		//
		//
		//	public static Page<BookSimpleResponseDto> fromEntityPage(Page<BookEntity> bookEntityPage) {
		//		return bookEntityPage.map(BookSimpleResponseDto::fromEntity);
		//	}
		Page<BookSimpleResponseDto> bookResponseDtoPage = Page.empty();//BookSimpleResponseDto.fromEntityPage(bookEntityPage);
		return ResponseEntity.ok(bookResponseDtoPage);
	}


	@PostMapping("/like/{bookId}")
	@ApiOperation(value = "책 찜하기 추가")
	public ResponseEntity<HttpStatus> createBookmark(@PathVariable String bookId) {
		bookmarkService.createBookmark(bookId);
		return new ResponseEntity<>(HttpStatus.OK);
	}


	@DeleteMapping("/like/{bookId}")
	@ApiOperation(value = "책 찜하기 취소")
	public ResponseEntity<HttpStatus> deleteBookmark(@PathVariable String bookId) {
		bookmarkService.deleteBookmark(bookId);
		return new ResponseEntity<>(HttpStatus.OK);
	}


	@PutMapping("/status/{bookStatusId}/reading")
	@ApiOperation(value = "책 상태 변경 | 완독(컬렉션) → 진행중(타이머)")
	public ResponseEntity<HttpStatus> modifyStatusToInprogress(@PathVariable String bookId) {
		bookStatusService.modifyStatusToInprogress(bookId);
		return new ResponseEntity<>(HttpStatus.OK);
	}


	@PutMapping("/status/{bookStatusId}/done")
	@ApiOperation(value = "책 상태 변경 | 진행중(타이머) → 완독(컬렉션)")
	public ResponseEntity<HttpStatus> modifyStatusToDone(@PathVariable String bookId) {
		bookStatusService.modifyStatusToDone(bookId);
		return new ResponseEntity<>(HttpStatus.OK);
	}


	@GetMapping("/simple/{bookId}")
	@ApiOperation(value = "도서 요약 정보를 조회합니다.")
	public ResponseEntity<BookSimpleResponseDto> getBookSimple(@PathVariable String bookId) {
		BookEntity book = bookService.getSimpleBook(bookId);

		//	public static BookSimpleResponseDto fromEntity(BookEntity bookEntity) {
		//		// TODO : 채우기
		//		return new BookSimpleResponseDto();
		//	}
		//
		//
		//	public static Page<BookSimpleResponseDto> fromEntityPage(Page<BookEntity> bookEntityPage) {
		//		return bookEntityPage.map(BookSimpleResponseDto::fromEntity);
		//	}
		BookSimpleResponseDto bookSimpleResponseDto = BookSimpleResponseDto.builder().build();//BookSimpleResponseDto.fromEntity(book);
		return ResponseEntity.ok(bookSimpleResponseDto);
	}

}
