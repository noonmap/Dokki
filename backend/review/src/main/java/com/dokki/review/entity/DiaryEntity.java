package com.dokki.review.entity;


import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import javax.persistence.*;


@Entity
@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Table(name = "diary")
public class DiaryEntity {

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
