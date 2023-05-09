package com.dokki.book.controller;


import com.dokki.book.config.exception.CustomException;
import com.dokki.book.dto.response.AladinItemResponseDto;
import com.dokki.book.dto.response.BookDetailResponseDto;
import com.dokki.book.dto.response.BookSearchResponseDto;
import com.dokki.book.entity.BookEntity;
import com.dokki.book.entity.BookMarkEntity;
import com.dokki.book.enums.SearchType;
import com.dokki.book.service.BookService;
import com.dokki.book.service.BookStatusService;
import com.dokki.book.service.BookmarkService;
import com.dokki.util.book.dto.response.BookSimpleResponseDto;
import com.dokki.util.common.error.ErrorCode;
import feign.FeignException;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Slice;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;


@Slf4j
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
		Long userId = 0L;   // TODO: user id 가져오기
		BookEntity bookEntity = bookService.getBook(bookId);
		BookDetailResponseDto bookDetailResponseDto = BookDetailResponseDto.fromEntity(bookEntity);
		if (bookEntity.getStatistics() != null) {
			try {
				bookDetailResponseDto.setUserData(bookStatusService.getUserBookInfo(userId, bookId));
				bookDetailResponseDto.setReview(bookService.get3Comment(bookId));
			} catch (FeignException e) {
				log.error("리뷰 조회 실패 - bookId : {}", bookId);
				log.error(e.getMessage());
			}
		}
		return ResponseEntity.ok(bookDetailResponseDto);
	}


	@GetMapping("/search")
	@ApiOperation(value = "도서 검색")
	public ResponseEntity<Slice<BookSearchResponseDto>> searchBookList(@RequestParam String search, @RequestParam String queryType, Pageable pageable) throws CustomException {
		// 검색어 없거나 빈 값일 경우
		if (StringUtils.isEmpty(search.trim())) {
			throw new CustomException(ErrorCode.INVALID_REQUEST);
		}
		Slice<AladinItemResponseDto> apiBookResponseDtoSlice = bookService.searchBookList(search.trim(), SearchType.findByName(queryType), pageable);
		Slice<BookSearchResponseDto> bookSearchResponseDtoSlice = BookSearchResponseDto.fromApiResponseSlice(apiBookResponseDtoSlice);
		return ResponseEntity.ok(bookSearchResponseDtoSlice);
	}


	@GetMapping("/like")
	@ApiOperation(value = "찜한 책 조회")
	public ResponseEntity<Slice<BookSearchResponseDto>> getBookmarkListByUserId(Pageable pageable) {
		Long userId = 0L;   // TODO: user id 가져오기
		Slice<BookMarkEntity> bookEntitySlice = bookmarkService.getBookmarkList(userId, pageable);
		Slice<BookSearchResponseDto> bookResponseDtoPage = BookSearchResponseDto.fromBookMarkEntitySlice(bookEntitySlice);
		return ResponseEntity.ok(bookResponseDtoPage);
	}


	@PostMapping("/like/{bookId}")
	@ApiOperation(value = "책 찜하기 추가")
	public ResponseEntity<HttpStatus> createBookmark(@PathVariable String bookId) {
		Long userId = 0L;   // TODO: user id 가져오기
		bookmarkService.createBookmark(userId, bookId);
		return new ResponseEntity<>(HttpStatus.OK);
	}


	@DeleteMapping("/like/{bookId}")
	@ApiOperation(value = "책 찜하기 취소")
	public ResponseEntity<HttpStatus> deleteBookmark(@PathVariable String bookId) {
		Long userId = 0L;   // TODO: user id 가져오기
		bookmarkService.deleteBookmark(userId, bookId);
		return new ResponseEntity<>(HttpStatus.OK);
	}


	@PostMapping("/status")
	@ApiOperation(value = "책 타이머뷰에 추가 | 상태 추가 또는 완독 -> 진행중으로 변경")
	public ResponseEntity<HttpStatus> createStatusToInprogress(@RequestBody Map<String, String> map) {
		Long userId = 0L;   // TODO: user id 가져오기
		bookStatusService.addBookToTimer(userId, map.get("bookId"));
		return new ResponseEntity<>(HttpStatus.OK);
	}


	@PutMapping("/status/{bookId}/complete")
	@ApiOperation(value = "책 상태 변경 | 진행중(타이머) → 완독(컬렉션)")
	public ResponseEntity<HttpStatus> modifyStatusToDone(@PathVariable Long bookStatusId) {
		Long userId = 0L;   // TODO: user id 가져오기
		bookStatusService.modifyStatusToDone(userId, bookStatusId);
		return new ResponseEntity<>(HttpStatus.OK);
	}


	@GetMapping("/simple/{bookId}")
	@ApiOperation(value = "도서 요약 정보를 조회합니다.")
	public ResponseEntity<BookSimpleResponseDto> getBookSimple(@PathVariable String bookId) {
		BookEntity book = bookService.getSimpleBook(bookId);
		BookSimpleResponseDto bookSimpleResponseDto = BookSimpleResponseDto.builder()
			.bookId(bookId)
			.bookTitle(book.getTitle())
			.bookCoverPath(book.getCoverFrontImagePath())
			.build();
		return ResponseEntity.ok(bookSimpleResponseDto);
	}


	@PostMapping("/simple/list")
	@ApiOperation(value = "도서 요약 정보의 리스트를 조회합니다.")
	public ResponseEntity<List<BookSimpleResponseDto>> getBookSimpleList(@RequestBody List<String> bookIdList) {
		List<BookEntity> bookList = bookService.getBookListByIdIn(bookIdList);
		List<BookSimpleResponseDto> result = bookList.stream().map(
			o -> BookSimpleResponseDto.builder()
				.bookId(o.getId())
				.bookTitle(o.getTitle())
				.bookCoverPath(o.getCoverFrontImagePath())
				.build()
		).collect(Collectors.toList());
		return ResponseEntity.ok(result);
	}

}
