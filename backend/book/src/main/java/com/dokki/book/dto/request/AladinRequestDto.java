package com.dokki.book.dto.request;


import lombok.*;


@Setter
@Getter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class AladinRequestDto {

	@Builder.Default
	private String version = "20131101";
	@Builder.Default
	private String output = "JS";

	private String ttbkey;

	private String queryType;
	private String searchTarget;
	private String start;
	private String maxResults;
	private String cover;
	private String query;

	// use in getItem (path - ItemLookUp)
	private String itemIdType;
	private String itemId;

}
