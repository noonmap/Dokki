package com.dokki.book.entity;


import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.LastModifiedDate;
import org.springframework.data.jpa.convert.threeten.Jsr310JpaConverters;

import javax.persistence.*;
import java.time.LocalDateTime;


@Entity
@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Table(name = "book_statistics")
public class BookStatisticsEntity {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Long id;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "book_id", nullable = false)
	private BookEntity bookId;

	@Column(nullable = false)
	private Integer completedUsers;

	@Column(nullable = false)
	private Integer readingUsers;

	@Column(nullable = false)
	private Integer bookmarkedUsers;

	@Column(nullable = false)
	private Float meanScore;

	@Column(nullable = false)
	private Integer meanReadTime;

	@CreatedDate
	@Column(columnDefinition = "DATETIME", updatable = false, nullable = false)
	@Convert(converter = Jsr310JpaConverters.LocalDateTimeConverter.class)
	private LocalDateTime created;

	@LastModifiedDate
	@Column(columnDefinition = "DATETIME", nullable = false)
	@Convert(converter = Jsr310JpaConverters.LocalDateTimeConverter.class)
	private LocalDateTime updated;

}
