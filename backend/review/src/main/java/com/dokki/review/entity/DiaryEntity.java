package com.dokki.review.entity;


import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.LastModifiedDate;
import org.springframework.data.jpa.convert.threeten.Jsr310JpaConverters;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import javax.persistence.*;
import java.time.LocalDateTime;


@Entity
@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Table(name = "diary")
@EntityListeners(AuditingEntityListener.class) // 이게 있어야 하위 클래스에서 createdAt, updatedAt가 자동 생성이 됨
public class DiaryEntity {

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
	@Column(nullable = false)
	private Long bookStatusId;
	@Column(nullable = false, columnDefinition = "TEXT")
	private String content;
	@Column(length = 500)
	private String diaryImagePath;


	public void updateContent(String content) {
		this.content = content;
	}


	public void updateDiaryImagePath(String diaryImagePath) {
		this.diaryImagePath = diaryImagePath;
	}

}
