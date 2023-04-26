package com.dokki.user.controller;

import com.dokki.user.dto.request.FollowRequestDto;
import com.dokki.user.dto.request.ProfileRequestDto;
import com.dokki.user.dto.response.ProfileResponseDto;
import com.dokki.util.user.dto.response.UserSimpleInfoDto;
import com.dokki.user.service.UserService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.SliceImpl;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import java.util.Arrays;
import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("api/users")
@Api(tags = {"Users"},description = "유저 관련 서비스")
@Slf4j
public class UserController {

    private final UserService userService;
    /**
     * 사용자 검색
     */
    @GetMapping("")
    @ApiOperation(value = "사용자 검색", notes = "사용자를 조회한다.")
    public ResponseEntity<?> getUserList(ProfileRequestDto profileRequestDto){
        List<UserSimpleInfoDto> mockUsers = Arrays.asList(
                new UserSimpleInfoDto(1L, "user1", "imagePath"),
                new UserSimpleInfoDto(2L, "user2", "imagePath"),
                new UserSimpleInfoDto(3L, "user3", "imagePath")
        );
        SliceImpl<UserSimpleInfoDto> userSimpleInfoDtoSlice = new SliceImpl<>(mockUsers);
        return ResponseEntity.ok(userSimpleInfoDtoSlice);
    }
    /**
     * 유저 프로필 정보 조회
     */
    @GetMapping("/profile/{userId}")
    @ApiOperation(value = "유저 프로필 정보 조회", notes = "유저 프로필 정보 조회")
    public ResponseEntity<?> getUserProfile(@PathVariable long userId){
        ProfileResponseDto profileResponseDto = ProfileResponseDto.builder()
                .userId(1)
                .nickname("nickname")
                .profileImagePath("imagePath")
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
    public ResponseEntity<?> modifyNickname(@RequestBody String nickname){
        return ResponseEntity.ok("OK");
    }
    /**
     * 유저 프로필 사진 수정
     */
    @PostMapping("/profile/image")
    @ApiOperation(value = "유저 프로필 사진 수정", notes = "유저 프로필 사진 수정")
    public ResponseEntity<?> modifyImage(@RequestPart MultipartFile uploadFile ){
        return ResponseEntity.ok("OK");
    }
    /**
     * 독끼풀 상태 조회
     */
    @GetMapping("/dokki/{userId}")
    @ApiOperation(value = "독끼풀 상태 조회", notes = "독끼풀 상태 조회")
    public ResponseEntity<?> getDokki(@PathVariable long userId){
        return ResponseEntity.ok("OK");
    }
    /**
     * 팔로우 목록 조회
     */
    @GetMapping("/follow/{userId}")
    @ApiOperation(value = "팔로우 목록 조회", notes = "팔로우 목록 조회")
    public ResponseEntity<?> getFollowList(@PathVariable long userId, FollowRequestDto followRequestDto){
        System.out.println(followRequestDto.getPage() +" " + followRequestDto.getSize());
        List<UserSimpleInfoDto> mockUsers = Arrays.asList(
                new UserSimpleInfoDto(1L, "follower1", "imagePath"),
                new UserSimpleInfoDto(2L, "follower2", "imagePath"),
                new UserSimpleInfoDto(3L, "follower3", "imagePath")
        );
        SliceImpl<UserSimpleInfoDto> userSimpleInfoDtoSlice = new SliceImpl<>(mockUsers);
        return ResponseEntity.ok(userSimpleInfoDtoSlice);
    }
    /**
     * 팔로우 추가
     */
    @PostMapping("/follow/{userId}")
    @ApiOperation(value = "팔로우 추가", notes = "팔로우 추가")
    public ResponseEntity<?> createFollow(@PathVariable long userId){
        return ResponseEntity.ok("OK");
    }
    /**
     * 팔로우 취소(언팔로우)
     */
    @DeleteMapping("/follow/{userId}")
    @ApiOperation(value = "팔로우 삭제", notes = "팔로우 삭제 -> 언팔로우")
    public ResponseEntity<?> deleteFollow(@PathVariable long userId){
        return ResponseEntity.ok("OK");
    }

}
