package com.dokki.review.controller;


import com.dokki.review.entity.DiaryEntity;
import com.dokki.review.service.DiaryService;
import com.dokki.util.review.dto.request.AIImageRequestDto;
import com.dokki.util.review.dto.request.DiaryRequestDto;
import com.dokki.util.review.dto.response.DiaryResponseDto;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
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


	@PostMapping("/{bookId}")
	@ApiOperation(value = "감정 일기 추가")
	public ResponseEntity<Boolean> createDiary(@PathVariable String bookId, @RequestBody DiaryRequestDto diaryRequestDto) {
		diaryService.createDiary(bookId, diaryRequestDto);
		return ResponseEntity.ok(true);
	}


	@PutMapping("/{diaryId}")
	@ApiOperation(value = "감정 일기 수정")
	public ResponseEntity<Boolean> modifyDiary(@PathVariable Long diaryId, @RequestBody DiaryRequestDto diaryRequestDto) {
		diaryService.modifyDiary(diaryId, diaryRequestDto);
		return ResponseEntity.ok(true);
	}


	@DeleteMapping("/{diaryId}")
	@ApiOperation(value = "감정 일기 삭제")
	public ResponseEntity<Boolean> deleteDiary(@PathVariable Long diaryId) {
		diaryService.deleteDiary(diaryId);
		return ResponseEntity.ok(true);
	}


	@GetMapping("/{bookId}")
	@ApiOperation(value = "관련 책에 대해 작성한 감정 일기 조회", notes = "N회독 했을 시, 감정일기가 여러 개 조회될 수 있다.")
	public ResponseEntity<Page<DiaryResponseDto>> getDiaryByBook(@PathVariable String bookId, Pageable pageable) {
		Page<DiaryEntity> diaryEntityPage = diaryService.getDiaryByBook(bookId, pageable);
		//		public static DiaryResponseDto fromEntity(DiaryEntity diaryEntity) {
		//			// TODO : 채우기
		//			return new DiaryResponseDto();
		//		}
		//
		//
		//		public static Page<DiaryResponseDto> fromEntityPage(Page<DiaryEntity> diaryEntityPage) {
		//			return diaryEntityPage.map(DiaryResponseDto::fromEntity);
		//		}

		Page<DiaryResponseDto> diaryResponseDtoPage = Page.empty();//DiaryResponseDto.fromEntityPage(diaryEntityPage);
		return ResponseEntity.ok(diaryResponseDtoPage);
	}


	@GetMapping
	@ApiOperation(value = "내가 작성한 모든 감정 일기 목록 조회")
	public ResponseEntity<Page<DiaryResponseDto>> getDiaryList(Pageable pageable) {
		Page<DiaryEntity> diaryEntityPage = diaryService.getDiaryList(pageable);
		//		public static DiaryResponseDto fromEntity(DiaryEntity diaryEntity) {
		//			// TODO : 채우기
		//			return new DiaryResponseDto();
		//		}
		//
		//
		//		public static Page<DiaryResponseDto> fromEntityPage(Page<DiaryEntity> diaryEntityPage) {
		//			return diaryEntityPage.map(DiaryResponseDto::fromEntity);
		//		}

		Page<DiaryResponseDto> diaryResponseDtoPage = Page.empty();//DiaryResponseDto.fromEntityPage(diaryEntityPage);
		return ResponseEntity.ok(diaryResponseDtoPage);
	}


	@PostMapping("/creation")
	@ApiOperation(value = "감정 일기 내용을 바탕으로 한 AI 이미지 생성", notes = "")
	public ResponseEntity<Map<String, String>> createAIImage(@RequestBody AIImageRequestDto aiImageRequestDto) {
		String imagePath = diaryService.createAIImage(aiImageRequestDto);
		Map<String, String> result = new HashMap<>();
		result.put("diaryImagePath", imagePath);
		return ResponseEntity.ok(result);
	}

}
