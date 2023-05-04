package com.dokki.review.controller;


import com.dokki.review.dto.request.AIImageRequestDto;
import com.dokki.review.dto.request.DiaryRequestDto;
import com.dokki.review.dto.response.DiaryResponseDto;
import com.dokki.review.service.DiaryImageService;
import com.dokki.review.service.DiaryService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Slice;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

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

	private final DiaryImageService diaryImageService;


	@PostMapping("/{bookId}")
	@ApiOperation(value = "감정 일기 추가")
	public ResponseEntity<Boolean> createDiary(@PathVariable String bookId, @RequestBody DiaryRequestDto diaryRequestDto) {
		// TODO : userId 넣기
		diaryService.createDiary(1L, bookId, diaryRequestDto);
		return ResponseEntity.ok(true);
	}


	@PutMapping("/{diaryId}")
	@ApiOperation(value = "감정 일기 수정")
	public ResponseEntity<Boolean> modifyDiary(@PathVariable Long diaryId, @RequestBody DiaryRequestDto diaryRequestDto) {
		// TODO : userId 넣기
		diaryService.modifyDiary(1L, diaryId, diaryRequestDto);
		return ResponseEntity.ok(true);
	}


	@DeleteMapping("/{diaryId}")
	@ApiOperation(value = "감정 일기 삭제")
	public ResponseEntity<Boolean> deleteDiary(@PathVariable Long diaryId) {
		// TODO : userId 넣기
		diaryService.deleteDiary(1L, diaryId);
		return ResponseEntity.ok(true);
	}


	@GetMapping("/{bookId}")
	@ApiOperation(value = "관련 책에 대해 작성한 감정 일기 조회")
	public ResponseEntity<DiaryResponseDto> getDiaryByBook(@PathVariable String bookId) {
		// TODO : userId 넣기
		DiaryResponseDto diaryEntityPage = diaryService.getDiaryByBook(1L, bookId);

		// 테스트
		//		diaryEntityPage = DiaryResponseDto.builder().bookId("9788952773326").bookTitle("위험한 과학책")
		//			.diaryImagePath("https://image.aladin.co.kr/product/5683/69/cover150/8952773322_2.jpg")
		//			.diaryContent("위험해위험해위험해위험해위험해위험해위험해위험해위험해위험해위험해").created(LocalDateTime.now()).build();
		return ResponseEntity.ok(diaryEntityPage);
	}


	@GetMapping
	@ApiOperation(value = "내가 작성한 모든 감정 일기 목록 조회")
	public ResponseEntity<Slice<DiaryResponseDto>> getDiaryList(Pageable pageable) {
		// TODO : userId 넣기
		Slice<DiaryResponseDto> diaryResponseDtoPage = diaryService.getDiaryList(1L, pageable);

		//		List<DiaryResponseDto> testList = new ArrayList<>();
		//		testList.add(DiaryResponseDto.builder().bookId("9791169257176").bookTitle("아주 위험한 과학책")
		//			.diaryImagePath("https://image.aladin.co.kr/product/31515/75/cover150/k672832531_1.jpg")
		//			.diaryContent("아주위험해아주위험해아주위험해아주위험해아주위험해아주위험해아주위험해").created(LocalDateTime.now()).build());
		//		testList.add(DiaryResponseDto.builder().bookId("9788952751546").bookTitle("더 위험한 과학책")
		//			.diaryImagePath("https://image.aladin.co.kr/product/22867/22/cover150/895275154x_1.jpg")
		//			.diaryContent("더위험해더위험해더위험해더위험해더위험해더위험해더위험해더위험해더위험해").created(LocalDateTime.now()).build());
		//		testList.add(DiaryResponseDto.builder().bookId("9788952773326").bookTitle("위험한 과학책")
		//			.diaryImagePath("https://image.aladin.co.kr/product/5683/69/cover150/8952773322_2.jpg")
		//			.diaryContent("위험해위험해위험해위험해위험해위험해위험해위험해위험해위험해위험해").created(LocalDateTime.now()).build());
		//		testList.add(DiaryResponseDto.builder().bookId("9791169257176").bookTitle("아주 위험한 과학책")
		//			.diaryImagePath("https://image.aladin.co.kr/product/31515/75/cover150/k672832531_1.jpg")
		//			.diaryContent("아주위험해아주위험해아주위험해아주위험해아주위험해아주위험해아주위험해").created(LocalDateTime.now()).build());
		//		testList.add(DiaryResponseDto.builder().bookId("9788952751546").bookTitle("더 위험한 과학책")
		//			.diaryImagePath("https://image.aladin.co.kr/product/22867/22/cover150/895275154x_1.jpg")
		//			.diaryContent("더위험해더위험해더위험해더위험해더위험해더위험해더위험해더위험해더위험해").created(LocalDateTime.now()).build());
		//		testList.add(DiaryResponseDto.builder().bookId("9788952773326").bookTitle("위험한 과학책")
		//			.diaryImagePath("https://image.aladin.co.kr/product/5683/69/cover150/8952773322_2.jpg")
		//			.diaryContent("위험해위험해위험해위험해위험해위험해위험해위험해위험해위험해위험해").created(LocalDateTime.now()).build());
		//		boolean hasNext = false;
		//		if (testList.size() > pageable.getPageSize()) {
		//			hasNext = true;
		//		}
		//		diaryResponseDtoPage = new SliceImpl<>(testList, pageable, hasNext);
		return ResponseEntity.ok(diaryResponseDtoPage);
	}


	@PostMapping("/image/creation")
	@ApiOperation(value = "감정 일기 내용을 바탕으로 한 AI 이미지 생성", notes = "")
	public ResponseEntity<Map<String, String>> createAIImage(@RequestBody AIImageRequestDto aiImageRequestDto) {
		// TODO : userId 넣기
		List<String> imagePath = diaryImageService.createAIImage(1L, aiImageRequestDto);
		// 테스트
		//		imagePath = "/default/image.png";
		Map<String, String> result = new HashMap<>();
		result.put("diaryImagePath", imagePath.get(0));
		return ResponseEntity.ok(result);
	}

}
