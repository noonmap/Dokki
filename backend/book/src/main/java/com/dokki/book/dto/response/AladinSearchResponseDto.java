package com.dokki.book.dto.response;


import lombok.*;

import java.util.List;


@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
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
