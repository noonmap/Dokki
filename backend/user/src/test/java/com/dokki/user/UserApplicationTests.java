package com.dokki.user;

import com.dokki.user.entity.UserEntity;
import com.dokki.user.repository.UserRepository;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import java.time.LocalDateTime;

@SpringBootTest
class UserApplicationTests {
	@Autowired
	UserRepository userRepository;

	@Test
	void contextLoads() {
	}

	@Test
	void createTest(){
		for(int i=0; i<10; i++) {
			UserEntity user = UserEntity.builder()
					.created(LocalDateTime.now())
					.email("testEmail")
					.followerCount(0)
					.followingCount(0)
					.kakaoId("testKakao")
					.updated(LocalDateTime.now())
					.nickname("testNickName")
					.profileImagePath("testImage")
					.password("testPassword")
					.build();
			userRepository.save(user);
		}
	}

}
