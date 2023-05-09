package com.dokki.book.entity;


import lombok.*;

import javax.persistence.*;
import java.time.LocalDate;


@ToString
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
	private String link;
	@Column(length = 500)
	private String coverFrontImagePath;
	@Column(length = 500)
	private String coverBackImagePath;
	@Column(length = 500)
	private String coverSideImagePath;
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
