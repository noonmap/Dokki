package com.dokki.book.client;


import com.dokki.book.dto.request.AladinRequestDto;
import com.dokki.book.dto.response.AladinSearchResponseDto;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.cloud.openfeign.SpringQueryMap;
import org.springframework.web.bind.annotation.GetMapping;


@FeignClient(name = "aladin-client", url = "http://www.aladin.co.kr/ttb/api/")
public interface AladinClient {

	/**
	 * 상품 리스트 API
	 */
	@GetMapping(value = "ItemList.aspx")
	AladinSearchResponseDto getBestSellerList(@SpringQueryMap AladinRequestDto request);

	/**
	 * 상품 검색 API
	 */
	@GetMapping(value = "ItemSearch.aspx")
	AladinSearchResponseDto getItemSearch(@SpringQueryMap AladinRequestDto request);

	/**
	 * 상품 조회 API
	 */
	@GetMapping(value = "ItemLookUp.aspx")
	AladinSearchResponseDto getItem(@SpringQueryMap AladinRequestDto request);

}
