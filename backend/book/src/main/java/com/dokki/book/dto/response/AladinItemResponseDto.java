package com.dokki.book.dto.response;


import com.dokki.book.entity.BookEntity;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.time.LocalDate;


@Getter
@Setter
@AllArgsConstructor
@ToString
public class AladinItemResponseDto {

	private String title;
	private String link;
	private String author;
	private LocalDate pubDate;
	private String description;
	private String isbn;
	private String isbn13;
	private int itemId;
	private int priceSales;
	private int priceStandard;
	private String mallType;
	private String stockStatus;
	private String cover;
	private int categoryId;
	private String categoryName;
	private String publisher;
	private AladinSubInfoResponseDto subInfo;


	public static BookEntity toEntity(AladinItemResponseDto detailResponse) {
		return BookEntity.builder()
			.id(detailResponse.getIsbn13())
			.title(detailResponse.getTitle())
			.coverImagePath(detailResponse.getCover())
			.summary(detailResponse.getDescription())
			.author(detailResponse.getAuthor())
			.publishDate(detailResponse.pubDate)
			.publisher(detailResponse.publisher)
			.totalPageCount(detailResponse.getSubInfo().getItemPage())
			.build();
	}

}