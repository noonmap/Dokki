package com.dokki.book.controller;


import com.dokki.book.service.CollectionService;
import com.dokki.util.book.dto.response.CollectionResponseDto;
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
@RequestMapping("/books/collections")
@Api(tags = "컬렉션 API")
public class CollectionController {

	private final CollectionService collectionService;


	// /books/collections/{userId}?page=&size=
	@GetMapping("/{userId}")
	@ApiOperation(value = "다 읽은 책 컬렉션 조회", notes = "")
	public ResponseEntity<Page<CollectionResponseDto>> getCollectionList(@PathVariable Long userId, @RequestParam Pageable pageable) {
		Page<CollectionResponseDto> collectionPage = collectionService.getCollectionList(userId, pageable);
		return ResponseEntity.ok(collectionPage);
	}


	//   /books/collections/{bookId}
	@DeleteMapping("/{bookId}")
	@ApiOperation(value = "다 읽은 책 컬렉션에서 삭제")
	public ResponseEntity<HttpStatus> deleteCollection(@PathVariable String bookId) {
		Long userId = 0L;   // TODO: userId 가져오기
		collectionService.deleteCollection(bookId, userId);
		return new ResponseEntity<>(HttpStatus.OK);
	}

}
