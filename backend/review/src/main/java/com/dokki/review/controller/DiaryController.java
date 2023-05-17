package com.dokki.review.controller;


import com.dokki.review.dto.request.AIImageRequestDto;
import com.dokki.review.dto.request.DiaryRequestDto;
import com.dokki.review.dto.response.DiaryImageResponseDto;
import com.dokki.review.dto.response.DiaryResponseDto;
import com.dokki.review.service.DiaryImageService;
import com.dokki.review.service.DiaryService;
import com.dokki.util.common.utils.FileUtils;
import com.dokki.util.common.utils.SessionUtils;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Slice;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;


@Log4j2
@RestController
@RequiredArgsConstructor
@RequestMapping("/reviews/diary")
@Api(tags = "감정 일기 API")
public class DiaryController {

	private final DiaryService diaryService;

	private final DiaryImageService diaryImageService;


	@PostMapping("/{bookId}")
	@ApiOperation(value = "감정 일기 추가")
	public ResponseEntity<Boolean> createDiary(@PathVariable String bookId, @RequestBody DiaryRequestDto diaryRequestDto) {
		Long userId = SessionUtils.getUserId();
		diaryService.createDiary(userId, bookId, diaryRequestDto);
		return ResponseEntity.ok(true);
	}


	@PutMapping("/{diaryId}")
	@ApiOperation(value = "감정 일기 수정")
	public ResponseEntity<Boolean> modifyDiary(@PathVariable Long diaryId, @RequestBody DiaryRequestDto diaryRequestDto) {
		Long userId = SessionUtils.getUserId();
		diaryService.modifyDiary(userId, diaryId, diaryRequestDto);
		return ResponseEntity.ok(true);
	}


	@DeleteMapping("/{diaryId}")
	@ApiOperation(value = "감정 일기 삭제")
	public ResponseEntity<Boolean> deleteDiary(@PathVariable Long diaryId) {
		Long userId = SessionUtils.getUserId();
		diaryService.deleteDiary(userId, diaryId);
		return ResponseEntity.ok(true);
	}


	@GetMapping("/{bookId}")
	@ApiOperation(value = "관련 책에 대해 작성한 감정 일기 조회")
	public ResponseEntity<DiaryResponseDto> getDiaryByBook(@PathVariable String bookId) {
		Long userId = SessionUtils.getUserId();
		DiaryResponseDto diaryEntityPage = diaryService.getDiaryByBook(userId, bookId);
		return ResponseEntity.ok(diaryEntityPage);
	}


	@GetMapping
	@ApiOperation(value = "내가 작성한 모든 감정 일기 목록 조회")
	public ResponseEntity<Slice<DiaryResponseDto>> getDiaryList(Pageable pageable) {
		Long userId = SessionUtils.getUserId();
		Slice<DiaryResponseDto> diaryResponseDtoPage = diaryService.getDiaryList(userId, pageable);
		return ResponseEntity.ok(diaryResponseDtoPage);
	}


	@PostMapping("/image/creation")
	@ApiOperation(value = "감정 일기 내용을 바탕으로 한 AI 이미지 생성", notes = "")
	public ResponseEntity<DiaryImageResponseDto> createAIImage(@RequestBody AIImageRequestDto aiImageRequestDto) {
		Long userId = SessionUtils.getUserId();
		String imagePath = diaryImageService.createAIImage(userId, aiImageRequestDto);
		Integer count = diaryImageService.getImageCreationRemainCount(userId);
		DiaryImageResponseDto diaryImageResponseDto = DiaryImageResponseDto.builder()
			.diaryImagePath(FileUtils.getAbsoluteFilePath(imagePath))
			.count(count)
			.build();
		return ResponseEntity.ok(diaryImageResponseDto);
	}


	@GetMapping("/image/count")
	@ApiOperation(value = "오늘 유저가 AI 이미지를 생성할 수 있는 남은 횟수를 반환 ", notes = "")
	public ResponseEntity<Map<String, Integer>> getImageCreationRemainCount() {
		Long userId = SessionUtils.getUserId();
		Integer count = diaryImageService.getImageCreationRemainCount(userId);
		Map<String, Integer> result = new HashMap<>();
		result.put("count", count);
		return ResponseEntity.ok(result);
	}

}
