package com.dokki.book.dto.response;


import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.util.List;


@Getter
@Setter
@AllArgsConstructor
@ToString
public class AladinSearchResponseDto {

	private Integer totalResults;
	private Integer startIndex;
	private Integer itemsPerPage;
	private String query;
	private String searchCategoryName;
	private List<AladinItemResponseDto> item;

	// 알라딘 api 에러 response
	private Integer errorCode;
	private String errorMessage;

}
