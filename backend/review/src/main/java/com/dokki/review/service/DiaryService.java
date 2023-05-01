package com.dokki.review.service;


import com.dokki.review.dto.request.AIImageRequestDto;
import com.dokki.review.dto.request.DiaryRequestDto;
import com.dokki.review.entity.DiaryEntity;
import com.dokki.review.repository.DiaryRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;


@Log4j2
@Service
@RequiredArgsConstructor
public class DiaryService {

	private final DiaryRepository diaryRepository;


	/**
	 * 감정 일기 생성
	 *
	 * @param bookId
	 * @param diaryRequestDto
	 */
	public void createDiary(String bookId, DiaryRequestDto diaryRequestDto) {
	}


	/**
	 * 감정 일기 수정
	 *
	 * @param diaryId
	 * @param diaryRequestDto
	 */
	public void modifyDiary(Long diaryId, DiaryRequestDto diaryRequestDto) {
	}


	/**
	 * 감정 일기 삭제
	 *
	 * @param diaryId
	 */
	public void deleteDiary(Long diaryId) {
	}


	/**
	 * 책에 대해 작성한 감정 일기 조회
	 *
	 * @param bookId
	 * @param pageable
	 * @return
	 */
	public DiaryEntity getDiaryByBook(String bookId, Pageable pageable) {
		return DiaryEntity.builder().build();
	}


	/**
	 * 내가 작성한 감정 일기 목록 조회
	 *
	 * @param pageable
	 * @return
	 */
	public Page<DiaryEntity> getDiaryList(Pageable pageable) {
		return Page.empty();
	}


	/**
	 * AI 이미지 생성
	 *
	 * @return 생성한 이미지 경로 반환
	 */
	public String createAIImage(AIImageRequestDto aiImageRequestDto) {
		return "";
	}

}
