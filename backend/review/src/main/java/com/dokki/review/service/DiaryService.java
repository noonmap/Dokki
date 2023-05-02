package com.dokki.review.service;


import com.dokki.review.client.BookClient;
import com.dokki.review.config.exception.CustomException;
import com.dokki.review.dto.request.AIImageRequestDto;
import com.dokki.review.dto.request.DiaryRequestDto;
import com.dokki.review.dto.response.DiaryResponseDto;
import com.dokki.review.entity.DiaryEntity;
import com.dokki.review.repository.DiaryRepository;
import com.dokki.util.book.dto.response.BookSimpleResponseDto;
import com.dokki.util.book.dto.response.CollectionSimpleResponseDto;
import com.dokki.util.common.enums.DefaultEnum;
import com.dokki.util.common.error.ErrorCode;
import feign.FeignException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Slice;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.concurrent.atomic.AtomicInteger;


@Slf4j
@Service
@RequiredArgsConstructor
public class DiaryService {

	private final DiaryRepository diaryRepository;
	private final BookClient bookClient;


	private boolean isSameUser(Long userId, Long commentId) {
		if (userId != commentId) {
			throw new CustomException(ErrorCode.INVALID_REQUEST);
		}
		return true;
	}


	public DiaryEntity getPresentDiary(Long diaryId) {
		return diaryRepository.findById(diaryId).orElseThrow(() -> new CustomException(ErrorCode.NOTFOUND_RESOURCE));
	}


	/**
	 * 감정 일기 생성
	 *
	 * @param bookId
	 * @param diaryRequestDto
	 */
	public void createDiary(Long userId, String bookId, DiaryRequestDto diaryRequestDto) {
		Long bookStatusId = Long.valueOf(DefaultEnum.BOOK_BOOK_STATUS_ID.getValue());
		try {
			// bookStatusId 조회
			CollectionSimpleResponseDto collectionSimpleInfo = bookClient.getCollectionSimple(bookId);
			bookStatusId = collectionSimpleInfo.getBookStatusId();
		} catch (FeignException e) {
			log.error(e.getMessage());
			// 조회 실패 시 exception 반환
		}
		// 생성
		DiaryEntity diary = DiaryEntity.builder()
			.userId(userId)
			.bookId(bookId)
			.bookStatusId(bookStatusId)
			.content(diaryRequestDto.getContent())
			.diaryImagePath(diaryRequestDto.getDiaryImagePath())
			.build();
		diaryRepository.save(diary);
	}


	/**
	 * 감정 일기 수정
	 *
	 * @param diaryId
	 * @param diaryRequestDto
	 */
	public void modifyDiary(Long userId, Long diaryId, DiaryRequestDto diaryRequestDto) {
		// diary 조회
		DiaryEntity diary = getPresentDiary(diaryId);

		// user 체크
		if (isSameUser(userId, diary.getUserId()) == false) return;

		// 수정
		diary.updateContent(diaryRequestDto.getContent());
		diary.updateDiaryImagePath(diaryRequestDto.getDiaryImagePath());
		diaryRepository.save(diary);
	}


	/**
	 * 감정 일기 삭제
	 *
	 * @param diaryId
	 */
	public void deleteDiary(Long userId, Long diaryId) {
		// diary 조회
		DiaryEntity diary = getPresentDiary(diaryId);

		// user 체크
		if (isSameUser(userId, diary.getUserId()) == false) return;

		// 삭제
		diaryRepository.delete(diary);
	}


	/**
	 * 책에 대해 작성한 감정 일기 조회
	 *
	 * @param bookId
	 * @return
	 */
	public DiaryResponseDto getDiaryByBook(Long userId, String bookId) {
		DiaryEntity diary = diaryRepository.findByUserIdAndBookId(userId, bookId).orElseThrow(() -> new CustomException(ErrorCode.NOTFOUND_RESOURCE));
		String bookTitle = DefaultEnum.BOOK_BOOK_TITLE.getValue();
		try {
			BookSimpleResponseDto bookSimpleResponseDto = bookClient.getBookSimple(bookId);
			bookTitle = bookSimpleResponseDto.getBookTitle();
		} catch (FeignException e) {
			log.error(e.getMessage());
		}
		DiaryResponseDto diaryResponseDto = DiaryResponseDto.builder()
			.bookId(diary.getBookId())
			.bookTitle(bookTitle)
			.diaryId(diary.getId())
			.diaryImagePath(diary.getDiaryImagePath())
			.diaryContent(diary.getContent())
			.created(diary.getCreatedAt())
			.build();
		return diaryResponseDto;
	}


	/**
	 * 내가 작성한 감정 일기 목록 조회
	 *
	 * @param pageable
	 * @return
	 */
	public Slice<DiaryResponseDto> getDiaryList(Long userId, Pageable pageable) {
		Slice<DiaryEntity> diaryEntitySlice = diaryRepository.findByUserIdOrderByCreatedAtDesc(userId, pageable);

		// bookId를 list로 생성
		List<String> bookIdList = diaryEntitySlice.map(d -> d.getBookId()).toList();
		Slice<DiaryResponseDto> diaryResponseDtoSlice;

		// book 정보 조회, book 정보를 diary와 연결
		try {
			List<BookSimpleResponseDto> bookSimpleInfoList = bookClient.getBookSimple(bookIdList);
			AtomicInteger counter = new AtomicInteger(0);
			diaryResponseDtoSlice = diaryEntitySlice.map(
				d -> {
					int idx = counter.getAndIncrement();
					return DiaryResponseDto.builder()
						.bookId(d.getBookId())
						.bookTitle(bookSimpleInfoList.get(idx).getBookTitle())
						.diaryId(d.getId())
						.diaryImagePath(d.getDiaryImagePath())
						.diaryContent(d.getContent())
						.created(d.getCreatedAt())
						.build();
				}
			);
		} catch (FeignException e) {
			log.error(e.getMessage());
			diaryResponseDtoSlice = diaryEntitySlice.map(
				d -> DiaryResponseDto.builder()
					.bookId(d.getBookId())
					.bookTitle(DefaultEnum.BOOK_BOOK_TITLE.getValue())
					.diaryId(d.getId())
					.diaryImagePath(d.getDiaryImagePath())
					.diaryContent(d.getContent())
					.created(d.getCreatedAt())
					.build()
			);
		}
		return diaryResponseDtoSlice;
	}


	/**
	 * AI 이미지 생성
	 *
	 * @return 생성한 이미지 경로 반환
	 */
	public String createAIImage(Long userId, AIImageRequestDto aiImageRequestDto) {
		// TODO : api 호출
		// redis에 이미지 생성 횟수 제한 걸어야 한다.
		return "";
	}

}
