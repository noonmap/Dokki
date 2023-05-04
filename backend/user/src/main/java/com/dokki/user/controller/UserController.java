package com.dokki.user.controller;


import com.dokki.user.config.exception.LogoutException;
import com.dokki.user.dto.ResponseMessage;
import com.dokki.user.dto.TokenDto;
import com.dokki.user.dto.request.ProfileRequestDto;
import com.dokki.user.dto.response.ProfileResponseDto;
import com.dokki.user.dto.response.UserResponseDto;
import com.dokki.user.error.ErrorCode;
import com.dokki.user.error.ErrorDto;
import com.dokki.user.security.filter.JwtFilter;
import com.dokki.user.service.FollowService;
import com.dokki.user.service.LoginService;
import com.dokki.user.service.UserService;
import com.dokki.util.user.dto.response.UserSimpleInfoDto;
import com.fasterxml.jackson.core.JsonProcessingException;
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
import java.util.Optional;


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
     * 로그인 테스트 미완성
     **/
    @GetMapping("/oauth2/code/kakao")
    public UserResponseDto login(@RequestParam String code) throws JsonProcessingException {
        UserResponseDto userResponseDto = loginService.login(code);
        HttpHeaders httpHeaders = new HttpHeaders();
        httpHeaders.add(JwtFilter.ACCESSTOKEN_HEADER, "Bearer " + "temp");
        httpHeaders.add(JwtFilter.REFRESHTOKEN_HEADER, "Bearer " + "temp");
        return userResponseDto;
    }
    /**
     * API-Gateway가 보내는 요청에 응답
     */
    @GetMapping("/auth")
    @ApiOperation(value = "gateway에게 유저 정보를 보냄", notes = "gateway에게 유저 정보를 보냄")
    public ResponseEntity<?> getAuth() throws Exception{
        Optional<UserSimpleInfoDto> userSimpleInfoDto = userService.getAuth();
        if(userSimpleInfoDto.isPresent()){
            return ResponseEntity.ok(userSimpleInfoDto.get());
        }else{
            return ResponseEntity.ok("FAIL");
        }
    }
    /**
     * 로그아웃
     */
    @GetMapping("/logout")
    public ResponseEntity<?> logout(HttpServletRequest request) throws Exception{
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
    public ResponseEntity<?> getUserList(ProfileRequestDto profileRequestDto){
        Slice<UserSimpleInfoDto> userSimpleInfoDtoSlice = userService.getUserList(profileRequestDto);
        return ResponseEntity.ok(userSimpleInfoDtoSlice);
    }
    /**
     * 유저 프로필 정보 조회
     */
    @GetMapping("/profile/{userId}")
    @ApiOperation(value = "유저 프로필 정보 조회", notes = "유저 프로필 정보 조회")
    public ResponseEntity<?> getUserProfile(@PathVariable long userId){
        ProfileResponseDto profileResponseDto = userService.getUserProfile(userId);
        return ResponseEntity.ok(profileResponseDto);
    }
    /**
     * 유저 닉네임 수정
     */
    @PutMapping("/profile/nickname")
    @ApiOperation(value = "유저 닉네임 수정", notes = "유저 닉네임 수정")
    public ResponseEntity<?> modifyNickname(@RequestBody String nickname){
        String response = userService.modifyNickname(nickname);
        return ResponseEntity.ok(response);
    }
    /**
     * 유저 프로필 사진 수정
     */
    @PostMapping("/profile/image")
    @ApiOperation(value = "유저 프로필 사진 수정", notes = "유저 프로필 사진 수정")
    public ResponseEntity<?> modifyImage(@RequestPart MultipartFile uploadFile ){
        try{
            String response = userService.modifyImage(uploadFile);
            if(response.equals("SUCCESS")){
                return ResponseEntity.ok(response);
            }else{
                return ResponseEntity.ok("수정 과정 중 오류가 발생함");
            }
        }catch (Exception e){
            e.printStackTrace();
            return ResponseEntity.ok("Fail");
        }
    }
    /**
     * 독끼풀 상태 조회
     */
    @GetMapping("/dokki/{userId}")
    @ApiOperation(value = "독끼풀 상태 조회", notes = "독끼풀 상태 조회")
    public ResponseEntity<?> getDokki(@PathVariable long userId){
        String response = userService.getDokki(userId);
        return ResponseEntity.ok(response);
    }
    /**
     * 리뷰 서비스에서 사용하는 간단 유저 정보 리스트
     */
    @PostMapping("/profile/simple")
    @ApiOperation(value = "리뷰 서버에서 사용하는 유저정보 리스트", notes = "독끼풀 상태 조회")
    public ResponseEntity<?> getUserSimpleforReview(@RequestBody List<Long> userIdList){
        log.info("리뷰서버 컨트롤러");
        List<UserSimpleInfoDto> userSimpleInfoDtoList = userService.getUserSimpleforReview(userIdList);
        return ResponseEntity.ok(userSimpleInfoDtoList);
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
