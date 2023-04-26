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

	private int totalResults;
	private int startIndex;
	private int itemsPerPage;
	private String query;
	private String searchCategoryName;
	private List<AladinItemResponseDto> item;

}
