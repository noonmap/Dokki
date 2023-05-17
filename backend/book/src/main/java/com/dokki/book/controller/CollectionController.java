package com.dokki.book.controller;


import com.dokki.book.dto.response.CollectionResponseDto;
import com.dokki.book.entity.BookStatusEntity;
import com.dokki.book.service.BookStatusService;
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


@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/books/collections")
@Api(tags = "컬렉션 API")
public class CollectionController {

	private final BookStatusService bookStatusService;

	
	@GetMapping("")
	@ApiOperation(value = "다 읽은 책 컬렉션 조회", notes = "")
	public ResponseEntity<Slice<CollectionResponseDto>> getCollectionList(@RequestParam Long userId, Pageable pageable) {
		Slice<BookStatusEntity> bookStatusEntitySlice = bookStatusService.getCollectionList(userId, pageable);
		Slice<CollectionResponseDto> collectionSlice = CollectionResponseDto.fromEntitySlice(bookStatusEntitySlice);
		return ResponseEntity.ok(collectionSlice);
	}


	@DeleteMapping("/{bookStatusId}")
	@ApiOperation(value = "다 읽은 책 컬렉션에서 삭제")
	public ResponseEntity<HttpStatus> deleteCollection(@PathVariable Long bookStatusId) {
		Long userId = SessionUtils.getUserId();
		bookStatusService.deleteStatus(userId, bookStatusId);
		return new ResponseEntity<>(HttpStatus.OK);
	}

}
