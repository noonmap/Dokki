package com.dokki.user.entity;


import lombok.*;
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
@Setter
@Table(name = "users") // 예약어 때문에 user가 아니라 users로 설정
@EntityListeners(AuditingEntityListener.class)
public class UserEntity {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Long id;

	@Column(nullable = false, length = 20)
	private String nickname;

	@Column(nullable = false, length = 20)
	private String kakaoId;

	@Column(nullable = true, length = 50)
	private String email;

	@Column(nullable = true, length = 500)
	private String profileImagePath;

	@Column(nullable = false)
	private Integer followerCount;

	@Column(nullable = false)
	private Integer followingCount;

	@Column(name = "password")
	private String password;

	@CreatedDate
	@Column(updatable = false, nullable = false)
	@Convert(converter = Jsr310JpaConverters.LocalDateTimeConverter.class)
	private LocalDateTime created;

	@LastModifiedDate
	@Column(nullable = false)
	@Convert(converter = Jsr310JpaConverters.LocalDateTimeConverter.class)
	private LocalDateTime updated;

	public void increaseFollowerCount() {
		this.followerCount++;
	}


	public void increaseFollowingCount() {
		this.followingCount++;
	}


	public void decreaseFollowerCount() {
		this.followerCount--;
	}


	public void decreaseFollowingCount() {
		this.followingCount--;
	}

}
