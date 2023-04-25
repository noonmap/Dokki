package com.dokki.book.enums;


import lombok.AllArgsConstructor;
import lombok.Getter;

import java.util.EnumSet;


@Getter
@AllArgsConstructor
/**
 * 검색어 종류
 * */
public enum SearchType {
	KEYWORD("Keyword"),
	TITLE("Title"),
	AUTHOR("Author");

	private String name;


	public static SearchType findByName(String name) {
		return EnumSet.allOf(SearchType.class).stream()
			.filter(e -> e.getName().equals(name))
			.findAny()
			.orElseThrow(IllegalArgumentException::new);
	}

}
