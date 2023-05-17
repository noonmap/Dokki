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
					.email("test@gmail"+i+".com")
					.followerCount(0)
					.followingCount(0)
					.kakaoId("testKakaoId"+i)
					.nickname("nickname"+i)
					.profileImagePath("https://blog.kakaocdn.net/dn/0mySg/btqCUccOGVk/nQ68nZiNKoIEGNJkooELF1/img.jpg")
					.password("testPassword"+i)
					.build();
			userRepository.save(user);
		}
	}

}
