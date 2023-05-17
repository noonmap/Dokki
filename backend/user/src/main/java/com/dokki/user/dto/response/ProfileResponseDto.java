package com.dokki.user.dto.response;


import com.dokki.user.entity.UserEntity;
import com.dokki.util.common.utils.FileUtils;
import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;


@AllArgsConstructor
@NoArgsConstructor
@Builder
@Data
public class ProfileResponseDto {

	private long userId;
	private String nickname;
	private String profileImagePath;
	private int followingCount;
	private int followerCount;
	@JsonProperty("isFollowed")
	private boolean isFollowed;


	public static ProfileResponseDto toDto(final UserEntity userEntity) {
		return ProfileResponseDto.builder()
			.userId(userEntity.getId())
			.nickname(userEntity.getNickname())
			.profileImagePath(FileUtils.getAbsoluteFilePath(userEntity.getProfileImagePath()))
			.followerCount(userEntity.getFollowerCount())
			.followingCount(userEntity.getFollowingCount())
			.isFollowed(false)
			.build();
	}

}
