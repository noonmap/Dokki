package com.dokki.review.controller;


import com.dokki.review.dto.request.AIImageRequestDto;
import com.dokki.review.dto.request.DiaryRequestDto;
import com.dokki.review.dto.response.DiaryResponseDto;
import com.dokki.review.entity.DiaryEntity;
import com.dokki.review.service.DiaryService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
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
	@ApiOperation(value = "관련 책에 대해 작성한 감정 일기 조회")
	public ResponseEntity<DiaryResponseDto> getDiaryByBook(@PathVariable String bookId, Pageable pageable) {
		DiaryEntity diaryEntityPage = diaryService.getDiaryByBook(bookId, pageable);

		// 테스트
		DiaryResponseDto test = DiaryResponseDto.builder().bookId("9788952773326").bookTitle("위험한 과학책")
			.diaryImagePath("https://image.aladin.co.kr/product/5683/69/cover150/8952773322_2.jpg")
			.diaryContent("위험해위험해위험해위험해위험해위험해위험해위험해위험해위험해위험해").created(LocalDateTime.now()).build();
		return ResponseEntity.ok(test);
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

		List<DiaryResponseDto> testList = new ArrayList<>();
		testList.add(DiaryResponseDto.builder().bookId("9791169257176").bookTitle("아주 위험한 과학책")
			.diaryImagePath("https://image.aladin.co.kr/product/31515/75/cover150/k672832531_1.jpg")
			.diaryContent("아주위험해아주위험해아주위험해아주위험해아주위험해아주위험해아주위험해").created(LocalDateTime.now()).build());
		testList.add(DiaryResponseDto.builder().bookId("9788952751546").bookTitle("더 위험한 과학책")
			.diaryImagePath("https://image.aladin.co.kr/product/22867/22/cover150/895275154x_1.jpg")
			.diaryContent("더위험해더위험해더위험해더위험해더위험해더위험해더위험해더위험해더위험해").created(LocalDateTime.now()).build());
		testList.add(DiaryResponseDto.builder().bookId("9788952773326").bookTitle("위험한 과학책")
			.diaryImagePath("https://image.aladin.co.kr/product/5683/69/cover150/8952773322_2.jpg")
			.diaryContent("위험해위험해위험해위험해위험해위험해위험해위험해위험해위험해위험해").created(LocalDateTime.now()).build());
		testList.add(DiaryResponseDto.builder().bookId("9791169257176").bookTitle("아주 위험한 과학책")
			.diaryImagePath("https://image.aladin.co.kr/product/31515/75/cover150/k672832531_1.jpg")
			.diaryContent("아주위험해아주위험해아주위험해아주위험해아주위험해아주위험해아주위험해").created(LocalDateTime.now()).build());
		testList.add(DiaryResponseDto.builder().bookId("9788952751546").bookTitle("더 위험한 과학책")
			.diaryImagePath("https://image.aladin.co.kr/product/22867/22/cover150/895275154x_1.jpg")
			.diaryContent("더위험해더위험해더위험해더위험해더위험해더위험해더위험해더위험해더위험해").created(LocalDateTime.now()).build());
		DiaryResponseDto test = DiaryResponseDto.builder().bookId("9788952773326").bookTitle("위험한 과학책")
			.diaryImagePath("https://image.aladin.co.kr/product/5683/69/cover150/8952773322_2.jpg")
			.diaryContent("위험해위험해위험해위험해위험해위험해위험해위험해위험해위험해위험해").created(LocalDateTime.now()).build();
		Page<DiaryResponseDto> diaryResponseDtoPage = new PageImpl<>(testList, pageable, testList.size());//DiaryResponseDto.fromEntityPage(diaryEntityPage);
		return ResponseEntity.ok(diaryResponseDtoPage);
	}


	@PostMapping("/creation")
	@ApiOperation(value = "감정 일기 내용을 바탕으로 한 AI 이미지 생성", notes = "")
	public ResponseEntity<Map<String, String>> createAIImage(@RequestBody AIImageRequestDto aiImageRequestDto) {
		String imagePath = diaryService.createAIImage(aiImageRequestDto);
		// 테스트
		imagePath = "/default/image.png";
		Map<String, String> result = new HashMap<>();
		result.put("diaryImagePath", imagePath);
		return ResponseEntity.ok(result);
	}

}
