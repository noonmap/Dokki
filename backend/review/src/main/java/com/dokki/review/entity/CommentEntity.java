package com.dokki.review.entity;


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
@Table(name = "comment")
public class CommentEntity {

	@CreatedDate
	@Column(updatable = false, nullable = false)
	@Convert(converter = Jsr310JpaConverters.LocalDateTimeConverter.class)
	public LocalDateTime createdAt;
	@LastModifiedDate
	@Column(nullable = false)
	@Convert(converter = Jsr310JpaConverters.LocalDateTimeConverter.class)
	public LocalDateTime updatedAt;
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Long id;
	@Column(nullable = false)
	private Long userId;
	@Column(nullable = false, length = 20)
	private String bookId;
	@Column(nullable = false, columnDefinition = "TEXT")
	private String content;
	@Column(nullable = false)
	private Float score;


	public void updateContent(String content) {
		this.content = content;
	}


	public void updateScore(Float score) {
		this.score = score;
	}

}
