package com.dokki.book.controller;


import com.dokki.book.config.exception.CustomException;
import com.dokki.book.dto.UserBookInfoDto;
import com.dokki.book.dto.request.BookCompleteRequestDto;
import com.dokki.book.dto.response.AladinItemResponseDto;
import com.dokki.book.dto.response.BookDetailResponseDto;
import com.dokki.book.dto.response.BookSearchResponseDto;
import com.dokki.book.entity.BookEntity;
import com.dokki.book.entity.BookMarkEntity;
import com.dokki.book.enums.SearchType;
import com.dokki.book.service.BookService;
import com.dokki.book.service.BookStatisticsService;
import com.dokki.book.service.BookStatusService;
import com.dokki.book.service.BookmarkService;
import com.dokki.util.book.dto.response.BookSimpleResponseDto;
import com.dokki.util.common.error.ErrorCode;
import com.dokki.util.common.utils.SessionUtils;
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

import java.util.Collections;
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
	private final BookStatisticsService bookStatisticsService;


	@GetMapping("")
	@ApiOperation(value = "추천 도서 조회")
	public ResponseEntity<Slice<BookSearchResponseDto>> getRecommendBookList(Pageable pageable) {
		Slice<AladinItemResponseDto> apiBookResponseDtoSlice = bookService.recommendBookList(pageable);
		Slice<BookSearchResponseDto> bookSearchResponseDtoSlice = BookSearchResponseDto.fromApiResponseSlice(apiBookResponseDtoSlice);
		return ResponseEntity.ok(bookSearchResponseDtoSlice);
	}


	@GetMapping("/{bookId}")
	@ApiOperation(value = "도서 상세 조회")
	public ResponseEntity<BookDetailResponseDto> getBook(@PathVariable String bookId) {
		Long userId = SessionUtils.getUserId();
		BookEntity bookEntity = bookService.getBook(bookId);
		BookDetailResponseDto bookDetailResponseDto = BookDetailResponseDto.fromEntity(bookEntity);
		if (bookEntity.getStatistics() == null) {   // 처음 저장하는 책인 경우
			bookDetailResponseDto.setUserData(new UserBookInfoDto());
			bookDetailResponseDto.setReview(Collections.emptyList());
		} else {
			bookDetailResponseDto.setUserData(bookStatusService.getUserBookInfo(userId, bookId));
			try {
				bookDetailResponseDto.setReview(bookService.get3Comment(bookId));
			} catch (FeignException e) {
				log.error("리뷰 조회 실패 - bookId : {}", bookId);
				log.error(e.getMessage());
				bookDetailResponseDto.setReview(Collections.emptyList());
			}
		}
		return ResponseEntity.ok(bookDetailResponseDto);
	}


	@GetMapping("/search")
	@ApiOperation(value = "도서 검색")
	public ResponseEntity<Slice<BookSearchResponseDto>> searchBookList(@RequestParam String search, @RequestParam String queryType, Pageable pageable) throws CustomException {
		// 검색어 없거나 빈 값일 경우
		if (!StringUtils.hasText(search)) {
			throw new CustomException(ErrorCode.INVALID_REQUEST);
		}
		Slice<AladinItemResponseDto> apiBookResponseDtoSlice = bookService.searchBookList(search.trim(), SearchType.findByName(queryType), pageable);
		Slice<BookSearchResponseDto> bookSearchResponseDtoSlice = BookSearchResponseDto.fromApiResponseSlice(apiBookResponseDtoSlice);
		return ResponseEntity.ok(bookSearchResponseDtoSlice);
	}


	@GetMapping("/like")
	@ApiOperation(value = "찜한 책 조회")
	public ResponseEntity<Slice<BookSearchResponseDto>> getBookmarkListByUserId(Pageable pageable) {
		Long userId = SessionUtils.getUserId();
		Slice<BookMarkEntity> bookEntitySlice = bookmarkService.getBookmarkList(userId, pageable);
		Slice<BookSearchResponseDto> bookResponseDtoPage = BookSearchResponseDto.fromBookMarkEntitySlice(bookEntitySlice);
		return ResponseEntity.ok(bookResponseDtoPage);
	}


	@PostMapping("/like/{bookId}")
	@ApiOperation(value = "책 찜하기 추가")
	public ResponseEntity<HttpStatus> createBookmark(@PathVariable String bookId) {
		Long userId = SessionUtils.getUserId();
		bookmarkService.createBookmark(userId, bookId);
		return new ResponseEntity<>(HttpStatus.OK);
	}


	@DeleteMapping("/like/{bookId}")
	@ApiOperation(value = "책 찜하기 취소")
	public ResponseEntity<HttpStatus> deleteBookmark(@PathVariable String bookId) {
		Long userId = SessionUtils.getUserId();
		bookmarkService.deleteBookmark(userId, bookId);
		return new ResponseEntity<>(HttpStatus.OK);
	}


	@PostMapping("/status")
	@ApiOperation(value = "책 타이머뷰에 추가 | 진행중 상태 추가 또는 완독 -> 진행중으로 변경")
	public ResponseEntity<HttpStatus> createOrModifyStatusToInprogress(@RequestBody Map<String, String> map) {
		Long userId = SessionUtils.getUserId();
		bookStatusService.createBookToTimer(userId, map.get("bookId"));
		return new ResponseEntity<>(HttpStatus.OK);
	}


	@DeleteMapping("/status/{bookStatusId}")
	@ApiOperation(value = "책 상태 삭제 | 타이머 또는 컬렉션에서 삭제")
	public ResponseEntity<HttpStatus> deleteStatus(@PathVariable Long bookStatusId) {
		Long userId = SessionUtils.getUserId();
		bookStatusService.deleteStatus(userId, bookStatusId);
		return new ResponseEntity<>(HttpStatus.OK);
	}


	@PostMapping("/status/direct-complete")
	@ApiOperation(value = "책 완독 추가")
	public ResponseEntity<HttpStatus> createStatusToDone(@RequestBody BookCompleteRequestDto dto) {
		Long userId = SessionUtils.getUserId();
		bookStatusService.createPastBookDone(userId, dto);
		return new ResponseEntity<>(HttpStatus.OK);
	}


	@PutMapping("/status/{bookStatusId}/complete")
	@ApiOperation(value = "책 상태 변경 | 진행중(타이머) → 완독(컬렉션)")
	public ResponseEntity<HttpStatus> modifyStatusToDone(@PathVariable Long bookStatusId) {
		Long userId = SessionUtils.getUserId();
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


	@PostMapping("/statistics/{bookId}/review")
	@ApiOperation(value = "[내부 호출] 리뷰 평균 점수를 통계에 업데이트합니다.")
	public ResponseEntity<HttpStatus> modifyStatisticsReviewScore(@PathVariable String bookId, @RequestParam float avgScore) {
		float score = (float) (Math.round(avgScore * 100) / 100.0);
		bookStatisticsService.modifyReviewScore(bookId, score);
		return new ResponseEntity<>(HttpStatus.OK);
	}

}
