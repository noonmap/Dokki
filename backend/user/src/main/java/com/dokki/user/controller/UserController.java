package com.dokki.user.controller;


import com.dokki.user.config.exception.LogoutException;
import com.dokki.user.dto.ResponseMessage;
import com.dokki.user.dto.TokenDto;
import com.dokki.user.dto.request.ProfileRequestDto;
import com.dokki.user.dto.response.ProfileResponseDto;
import com.dokki.user.error.ErrorCode;
import com.dokki.user.error.ErrorDto;
import com.dokki.user.security.filter.JwtFilter;
import com.dokki.user.service.FollowService;
import com.dokki.user.service.LoginService;
import com.dokki.user.service.UserService;
import com.dokki.util.user.dto.response.UserSimpleInfoDto;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Slice;
import org.springframework.data.domain.SliceImpl;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import java.util.Arrays;
import java.util.List;


@RestController
@RequiredArgsConstructor
@RequestMapping("users")
@Api(tags = { "Users" }, description = "유저 관련 서비스")
@Slf4j
public class UserController {

	private final UserService userService;
	private final LoginService loginService;
	private final FollowService followService;


	/**
	 * 로그인
	 */
	@GetMapping("/login")
	@ApiOperation(value = "로그인", notes = "카카오를 이용한 로그인")
	public ResponseEntity<?> googleLogin(@RequestParam("code") String code) throws Exception {
		ProfileResponseDto dto = null;//userService.login(code);
		HttpHeaders httpHeaders = new HttpHeaders();
		//httpHeaders.add(JwtFilter.ACCESSTOKEN_HEADER, "Bearer " + "temp");
		//httpHeaders.add(JwtFilter.REFRESHTOKEN_HEADER, "Bearer " + "temp");

		return new ResponseEntity<>(dto, httpHeaders, HttpStatus.OK);
	}


	/**
	 * 로그아웃
	 */
	@GetMapping("/logout")
	public ResponseEntity<?> logout(HttpServletRequest request) throws Exception {
		String accessToken = request.getHeader(JwtFilter.ACCESSTOKEN_HEADER);
		String refreshToken = request.getHeader(JwtFilter.REFRESHTOKEN_HEADER);
		TokenDto tokenDto = new TokenDto(accessToken, refreshToken);
		ResponseMessage responseMessage = loginService.logout(tokenDto);
		return ResponseEntity.ok("OK");
	}


	/**
	 * 엑세스 만료직전
	 */
	@GetMapping("/refresh")
	public ResponseEntity<?> refresh(HttpServletRequest request) {
		String refreshToken = request.getHeader(JwtFilter.REFRESHTOKEN_HEADER);
		try {
			TokenDto tokenDto = loginService.refresh(refreshToken);
			HttpHeaders httpHeaders = new HttpHeaders();
			httpHeaders.add(JwtFilter.ACCESSTOKEN_HEADER, "Bearer " + tokenDto.getAccessToken());
			httpHeaders.add(JwtFilter.REFRESHTOKEN_HEADER, "Bearer " + tokenDto.getRefreshToken());
			return new ResponseEntity<>(tokenDto, httpHeaders, HttpStatus.OK);
		} catch (LogoutException e) {
			ErrorDto error = new ErrorDto(ErrorCode.PLZ_RELOGIN.getMessage(), ErrorCode.PLZ_RELOGIN.getCode());

			return new ResponseEntity<>(error, HttpStatus.UNAUTHORIZED);
		}
	}


	/**
	 * 엑세스 만료 후 리프레시는 살아있을 때
	 */
	@GetMapping("/reissue")
	public ResponseEntity<?> reissue(HttpServletRequest request) throws LogoutException {

		String refreshToken = request.getHeader(JwtFilter.REFRESHTOKEN_HEADER);
		TokenDto tokenDto = loginService.reissue(refreshToken);
		HttpHeaders httpHeaders = new HttpHeaders();
		httpHeaders.add(JwtFilter.ACCESSTOKEN_HEADER, "Bearer " + tokenDto.getAccessToken());
		httpHeaders.add(JwtFilter.REFRESHTOKEN_HEADER, "Bearer " + tokenDto.getRefreshToken());
		return new ResponseEntity<>(tokenDto, httpHeaders, HttpStatus.OK);
	}


	/**
	 * 사용자 검색
	 */
	@GetMapping("")
	@ApiOperation(value = "사용자 검색", notes = "사용자를 조회한다.")
	public ResponseEntity<?> getUserList(ProfileRequestDto profileRequestDto) {
		List<UserSimpleInfoDto> mockUsers = Arrays.asList(
			new UserSimpleInfoDto(1L, "user1", "https://t1.daumcdn.net/crms/symbol_img/symbol_%EC%B9%B4%EC%B9%B4%EC%98%A4%ED%86%A1.png"),
			new UserSimpleInfoDto(2L, "user2", "https://t1.daumcdn.net/crms/symbol_img/symbol_%EC%B9%B4%EC%B9%B4%EC%98%A4%ED%86%A1.png"),
			new UserSimpleInfoDto(3L, "user3", "https://t1.daumcdn.net/crms/symbol_img/symbol_%EC%B9%B4%EC%B9%B4%EC%98%A4%ED%86%A1.png")
		);
		SliceImpl<UserSimpleInfoDto> userSimpleInfoDtoSlice = new SliceImpl<>(mockUsers);
		return ResponseEntity.ok(userSimpleInfoDtoSlice);
	}


	/**
	 * 유저 프로필 정보 조회
	 */
	@GetMapping("/profile/{userId}")
	@ApiOperation(value = "유저 프로필 정보 조회", notes = "유저 프로필 정보 조회")
	public ResponseEntity<?> getUserProfile(@PathVariable long userId) {
		ProfileResponseDto profileResponseDto = ProfileResponseDto.builder()
			.userId(1)
			.nickname("nickname")
			.profileImagePath("https://t1.daumcdn.net/crms/symbol_img/symbol_%EC%B9%B4%EC%B9%B4%EC%98%A4%ED%86%A1.png")
			.followerCount(5)
			.followingCount(100)
			.isFollowed(true)
			.build();
		return ResponseEntity.ok(profileResponseDto);
	}


	/**
	 * 유저 닉네임 수정
	 */
	@PutMapping("/profile/nickname")
	@ApiOperation(value = "유저 닉네임 수정", notes = "유저 닉네임 수정")
	public ResponseEntity<?> modifyNickname(@RequestBody String nickname) {
		return ResponseEntity.ok("OK");
	}


	/**
	 * 유저 프로필 사진 수정
	 */
	@PostMapping("/profile/image")
	@ApiOperation(value = "유저 프로필 사진 수정", notes = "유저 프로필 사진 수정")
	public ResponseEntity<?> modifyImage(@RequestPart MultipartFile uploadFile) {
		return ResponseEntity.ok("OK");
	}


	/**
	 * 독끼풀 상태 조회
	 */
	@GetMapping("/dokki/{userId}")
	@ApiOperation(value = "독끼풀 상태 조회", notes = "독끼풀 상태 조회")
	public ResponseEntity<?> getDokki(@PathVariable long userId) {
		return ResponseEntity.ok("OK");
	}


	/**
	 * 팔로우 하고 있는 사람 목록 조회
	 */
	@GetMapping("/following/{userId}")
	@ApiOperation(value = "유저가 팔로우 한 사람 목록 조회", notes = "유저가 팔로우 한 사람 목록 조회")
	public ResponseEntity<Slice<UserSimpleInfoDto>> getFollowingList(@PathVariable Long userId, Pageable pageable) {
		Slice<UserSimpleInfoDto> followings = followService.getFollowingList(userId, pageable);
		//		List<UserSimpleInfoDto> mockUsers = Arrays.asList(
		//			new UserSimpleInfoDto(1L, "follower1", "imagePath"),
		//			new UserSimpleInfoDto(2L, "follower2", "imagePath"),
		//			new UserSimpleInfoDto(3L, "follower3", "imagePath")
		//		);
		//        followings= new SliceImpl<>(mockUsers);
		return ResponseEntity.ok(followings);
	}


	/**
	 * 팔로워 목록 조회
	 */
	@GetMapping("/follower/{userId}")
	@ApiOperation(value = "팔로워 목록 조회", notes = "팔로워 목록 조회")
	public ResponseEntity<Slice<UserSimpleInfoDto>> getFollowerList(@PathVariable Long userId, Pageable pageable) {
		Slice<UserSimpleInfoDto> followers = followService.getFollowerList(userId, pageable);
		//		List<UserSimpleInfoDto> mockUsers = Arrays.asList(
		//			new UserSimpleInfoDto(1L, "follower1", "imagePath"),
		//			new UserSimpleInfoDto(2L, "follower2", "imagePath"),
		//			new UserSimpleInfoDto(3L, "follower3", "imagePath")
		//		);
		//		followers = new SliceImpl<>(mockUsers);
		return ResponseEntity.ok(followers);
	}


	/**
	 * 팔로우 추가
	 */
	@PostMapping("/follow/{userId}")
	@ApiOperation(value = "팔로우 추가", notes = "팔로우 추가")
	public ResponseEntity<Boolean> createFollow(@PathVariable Long userId) {
		// TODO : 유저 id 추가
		followService.createFollow(3L, userId);
		return ResponseEntity.ok(true);
	}


	/**
	 * 팔로우 취소(언팔로우)
	 */
	@DeleteMapping("/follow/{userId}")
	@ApiOperation(value = "팔로우 삭제", notes = "팔로우 삭제 -> 언팔로우")
	public ResponseEntity<Boolean> deleteFollow(@PathVariable Long userId) {
		// TODO : 유저 id 추가
		followService.deleteFollow(3L, userId);
		return ResponseEntity.ok(true);
	}

}
