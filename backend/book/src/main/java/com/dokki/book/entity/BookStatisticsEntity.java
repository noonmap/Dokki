package com.dokki.book.entity;


import lombok.*;
import org.hibernate.annotations.ColumnDefault;
import org.hibernate.annotations.DynamicInsert;
import org.hibernate.annotations.DynamicUpdate;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.LastModifiedDate;
import org.springframework.data.jpa.convert.threeten.Jsr310JpaConverters;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import javax.persistence.*;
import java.time.LocalDateTime;


@ToString

@Entity

@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor(access = AccessLevel.PRIVATE)
@Builder
@EntityListeners(AuditingEntityListener.class)      // date 자동 추가 및 수정
@DynamicInsert      // insert 시 null인 필드 제외
@DynamicUpdate
@Table(name = "book_statistics")
public class BookStatisticsEntity {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Long id;

	@OneToOne
	@JoinColumn(name = "book_id", nullable = false)
	private BookEntity bookId;

	@Column(nullable = false)
	@ColumnDefault("0")
	private Integer completedUsers;

	@Column(nullable = false)
	@ColumnDefault("0")
	private Integer readingUsers;

	@Column(nullable = false)
	@ColumnDefault("0")
	private Integer bookmarkedUsers;

	@Column(nullable = false)
	@ColumnDefault("0.0")
	private Float meanScore;

	@Column(nullable = false)
	@ColumnDefault("0")
	private Integer meanReadTime;

	@CreatedDate
	@Column(columnDefinition = "DATETIME", updatable = false, nullable = false)
	@Convert(converter = Jsr310JpaConverters.LocalDateTimeConverter.class)
	private LocalDateTime created;

	@LastModifiedDate
	@Column(columnDefinition = "DATETIME", nullable = false)
	@Convert(converter = Jsr310JpaConverters.LocalDateTimeConverter.class)
	private LocalDateTime updated;


	/**
	 * bookStatistics 새로 생성할 때 사용하는 생성자
	 */
	public BookStatisticsEntity(BookEntity bookId) {
		this.completedUsers = 0;
		this.readingUsers = 0;
		this.bookmarkedUsers = 0;
		this.meanScore = 0.0F;
		this.meanReadTime = 0;
		this.bookId = bookId;
	}

}
