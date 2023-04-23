package com.dokki.review.entity;


import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.LastModifiedDate;
import org.springframework.data.jpa.convert.threeten.Jsr310JpaConverters;

import javax.persistence.*;
import java.time.LocalDate;


@Entity
@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Table(name = "diary")
public class DiaryEntity {

	@CreatedDate
	@Column(updatable = false, nullable = false)
	@Convert(converter = Jsr310JpaConverters.LocalDateConverter.class)
	public LocalDate createdAt;
	@LastModifiedDate
	@Column(nullable = false)
	@Convert(converter = Jsr310JpaConverters.LocalDateConverter.class)
	public LocalDate updatedAt;
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Long id;
	@Column(nullable = false)
	private Long userId;
	@Column(nullable = false, length = 20)
	private String bookId;
	@Column(nullable = false)
	private Long bookStatusId;
	@Column(nullable = false, columnDefinition = "TEXT")
	private String content;
	@Column(length = 500)
	private String aiImagePath;

}
