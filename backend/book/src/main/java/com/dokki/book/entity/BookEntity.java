package com.dokki.book.entity;


import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import javax.persistence.*;
import java.time.LocalDate;


@Entity
@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Table(name = "book")
public class BookEntity {

	@Id
	@Column(nullable = false, length = 20)
	private String id;
	@Column(nullable = false, length = 200)
	private String title;
	@Column(length = 500)
	private String coverImagePath;
	@Column(columnDefinition = "TEXT")
	private String summary;
	@Column(nullable = false, length = 100)
	private String author;
	@Column(nullable = false, columnDefinition = "DATE")
	private LocalDate publishDate;
	@Column(nullable = false, length = 100)
	private String publisher;
	@Column(nullable = false)
	private Integer totalPageCount;

	@OneToOne(mappedBy = "bookId")
	private BookStatisticsEntity statistics;

}
