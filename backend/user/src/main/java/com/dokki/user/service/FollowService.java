package com.dokki.user.service;


import com.dokki.user.config.exception.CustomException;
import com.dokki.user.entity.FollowEntity;
import com.dokki.user.entity.UserEntity;
import com.dokki.user.repository.FollowRepository;
import com.dokki.user.repository.UserRepository;
import com.dokki.util.common.error.ErrorCode;
import com.dokki.util.common.utils.FileUtils;
import com.dokki.util.user.dto.response.UserSimpleInfoDto;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Slice;
import org.springframework.stereotype.Service;


@Slf4j
@Service
@RequiredArgsConstructor
public class FollowService {

	private final UserRepository userRepository;

	private final FollowRepository followRepository;


	private UserEntity getUser(Long userId) {
		return userRepository.findById(userId).orElseThrow(() -> new CustomException(ErrorCode.NOTFOUND_RESOURCE));
	}


	public Slice<UserSimpleInfoDto> getFollowingList(Long userId, Pageable pageable) {
		// 팔로잉 유저 조회
		Slice<FollowEntity> followingList = followRepository.findByFromUserIdOrderByIdDesc(userId);
		/**
		 * TODO: N+1문제 고려할 점
		 * userEntity를 조회할 때 findAll이 성능 상 낫지 않을까?
		 * followingList 조회할 때 N+1 문제 100퍼 뜬다...
		 * List<Long> followingUserIdList => List<UserEntity> followingUser => Slice<UserEntity>
		 *     이렇게 갈 수 있을 것 같다.
		 */
		// 팔로잉 유저 Entity 추출
		Slice<UserEntity> followingUserList = followingList.map(f -> f.getToUser());
		Slice<UserSimpleInfoDto> followingSimpleInfo = followingUserList.map(f -> UserSimpleInfoDto.builder()
			.userId(f.getId())
			.nickname(f.getNickname())
			.profileImagePath(FileUtils.getAbsoluteFilePath(f.getProfileImagePath()))
			.build());
		return followingSimpleInfo;
	}


	public Slice<UserSimpleInfoDto> getFollowerList(Long userId, Pageable pageable) {
		// 팔로워 유저 조회
		Slice<FollowEntity> followerList = followRepository.findByToUserIdOrderByIdDesc(userId);
		// TODO : 마찬가지로 N+1 문제
		// 팔로워 유저 Entity 추출
		Slice<UserEntity> followerUserList = followerList.map(f -> f.getFromUser());
		Slice<UserSimpleInfoDto> followerSimpleInfo = followerUserList.map(f -> UserSimpleInfoDto.builder()
			.userId(f.getId())
			.nickname(f.getNickname())
			.profileImagePath(FileUtils.getAbsoluteFilePath(f.getProfileImagePath()))
			.build());
		return followerSimpleInfo;
	}


	public void createFollow(Long userId, Long followUserId) {
		UserEntity user = getUser(userId);
		UserEntity followUser = getUser(followUserId);

		// 이미 팔로우하고 있는지 확인
		if (followRepository.existsByFromUserIdAndToUserId(userId, followUserId)) {
			throw new CustomException(ErrorCode.DUPLICATE_RESOURCE);
		}
		// 팔로우 안하고 있으면 팔로우 하기
		FollowEntity follow = FollowEntity.builder().fromUser(user).toUser(followUser).build();
		followRepository.save(follow);

		// follow count++ 해주기
		user.increaseFollowingCount();
		followUser.increaseFollowerCount();
		userRepository.save(user);
		userRepository.save(followUser);
	}


	public void deleteFollow(Long userId, Long followUserId) {
		UserEntity user = getUser(userId);
		UserEntity followUser = getUser(followUserId);

		// 존재하지 않는 팔로우이면 에러
		FollowEntity follow = followRepository.findByFromUserIdAndToUserId(userId, followUserId).orElseThrow(() -> new CustomException(ErrorCode.NOTFOUND_RESOURCE));

		// 팔로잉 삭제
		followRepository.delete(follow);

		// follow count-- 해주기
		user.decreaseFollowingCount();
		followUser.decreaseFollowerCount();
		userRepository.save(user);
		userRepository.save(followUser);
	}

}
