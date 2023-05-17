package com.dokki.book.service;


import com.dokki.book.client.AladinClient;
import com.dokki.book.config.exception.CustomException;
import com.dokki.book.dto.request.AladinRequestDto;
import com.dokki.book.dto.response.AladinItemResponseDto;
import com.dokki.book.dto.response.AladinSearchResponseDto;
import com.dokki.book.enums.SearchType;
import com.dokki.util.common.error.ErrorCode;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.io.IOException;


@Slf4j
@Service
@RequiredArgsConstructor
public class AladinService {

	private static final String ALADIN_API_KEY = "ttbtjrghks961722001";

	private final AladinClient aladinClient;


	public AladinItemResponseDto getBook(String bookId) throws RuntimeException {
		// set parameter and send request
		AladinSearchResponseDto result = aladinClient.getItem(AladinRequestDto.builder()
			.ttbkey(ALADIN_API_KEY)
			.queryType("Bestseller")
			.cover("big")
			.itemIdType("ISBN13")
			.itemId(bookId)
			.build());

		// aladin api error handle
		if (result.getErrorCode() != null) {
			if (result.getErrorCode() == 8) { // aladin errorcode about item not exist
				throw new CustomException(ErrorCode.NOTFOUND_RESOURCE);
			} else {
				log.error(result.getErrorMessage());
				throw new RuntimeException(result.getErrorMessage());
			}
		}

		// api detail search provide only 1 item
		return result.getItem().get(0);
	}


	public AladinSearchResponseDto getBestSellerList(Pageable pageable) {
		// set parameter and send request
		AladinSearchResponseDto result = aladinClient.getBestSellerList(AladinRequestDto.builder()
			.ttbkey(ALADIN_API_KEY)
			.queryType("Bestseller")
			.searchTarget("Book")
			.maxResults(Integer.toString(pageable.getPageSize()))
			.start(Integer.toString(pageable.getPageNumber()))
			.build());

		// aladin api error handle
		if (result.getErrorCode() != null) {
			throw new RuntimeException(result.getErrorMessage());
		}

		return result;
	}


	public AladinSearchResponseDto searchBookList(String search, SearchType queryType, Pageable pageable) throws IOException, RuntimeException {
		// set parameter and send request
		AladinSearchResponseDto result = aladinClient.getItemSearch(AladinRequestDto.builder()
			.ttbkey(ALADIN_API_KEY)
			.queryType(queryType.getName())
			.cover("midbig")
			.maxResults(Integer.toString(pageable.getPageSize()))
			.start(Integer.toString(pageable.getPageNumber()))
			.query(search)
			.build());

		// aladin api error handle
		if (result.getErrorCode() != null) {
			throw new RuntimeException(result.getErrorMessage());
		}

		return result;
	}

}
