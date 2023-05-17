package com.dokki.user.service;


import com.dokki.user.config.exception.CustomException;
import com.dokki.user.dto.ProfileDto;
import com.dokki.user.dto.request.ProfileRequestDto;
import com.dokki.user.dto.response.ProfileResponseDto;
import com.dokki.user.entity.UserEntity;
import com.dokki.user.repository.FollowRepository;
import com.dokki.user.repository.UserRepository;
import com.dokki.user.security.SecurityUtil;
import com.dokki.util.common.error.ErrorCode;
import com.dokki.util.common.utils.FileUtils;
import com.dokki.util.user.dto.response.UserSimpleInfoDto;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.io.FilenameUtils;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Slice;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import javax.transaction.Transactional;
import java.io.File;
import java.io.IOException;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.UUID;


@Service
@Slf4j
@RequiredArgsConstructor
public class UserService {

	private final UserRepository userRepository;
	private final FollowRepository followRepository;
	@Value("${app.fileupload.uploadPath}")
	String uploadPath;
	@Value("${app.fileupload.uploadDir}")
	String uploadFolder;


	/**
	 * 사용자 검색
	 * private String search;
	 * private int page;
	 * private int size;
	 */
	public Slice<UserSimpleInfoDto> getUserList(ProfileRequestDto profileRequestDto) {
		try {
			Slice<UserEntity> userListSlice = userRepository.findSliceByNicknameContains(
				profileRequestDto.getSearch(),
				PageRequest.of(profileRequestDto.getPage(), profileRequestDto.getSize()));
			Slice<UserSimpleInfoDto> userSimpleInfoDtoSlice =
				userListSlice.map(entity -> UserSimpleInfoDto.builder()
					.userId(entity.getId())
					.nickname(entity.getNickname())
					.profileImagePath(entity.getProfileImagePath())
					.build()
				);
			return userSimpleInfoDtoSlice;
		} catch (RuntimeException e) {
			e.printStackTrace();
			throw new CustomException(ErrorCode.UNKNOWN_ERROR);
		}
	}


	/**
	 * 유저 프로필 정보 조회
	 */
	public ProfileResponseDto getUserProfile(long userId) {
		try {
			Optional<ProfileResponseDto> profileResponseDto = userRepository.findById(userId).map(ProfileResponseDto::toDto);
			Long id = Long.valueOf(SecurityUtil.getCurrentId().get());
			if (userId == id) {
				return profileResponseDto.get();
			} else {
				boolean isFollowed = followRepository.existsByFromUserIdAndToUserId(id, userId);
				profileResponseDto.get().setFollowed(isFollowed);
				return profileResponseDto.get();
			}
		} catch (RuntimeException e) {
			e.printStackTrace();
			throw new CustomException(ErrorCode.UNKNOWN_ERROR);
		}
	}


	/**
	 * 유저 닉네임 수정
	 */
	public String modifyNickname(String nickname) {
		/** 현재 사용자 정보를 가져와서 id로 조회를 한다.**/
		try {
			Long id = Long.valueOf(SecurityUtil.getCurrentId().get());
			Optional<UserEntity> user = userRepository.findById(id);
			if (user.isPresent()) {
				user.get().setNickname(nickname);
				userRepository.save(user.get());
				log.info(nickname);
				return nickname;
			} else {
				throw new CustomException(ErrorCode.UNKNOWN_ERROR);
			}
		} catch (RuntimeException e) {
			e.printStackTrace();
			throw new CustomException(ErrorCode.UNKNOWN_ERROR);
		}

	}


	/**
	 * 유저 이미지 파일 수정
	 */
	@Transactional
	public ProfileDto modifyImage(MultipartFile uploadFile) {
		try {
			String pathName = uploadPath + File.separator + uploadFolder + File.separator;
			File uploadDir = new File(pathName);
			if (!uploadDir.exists()) uploadDir.mkdir();

			String fileName = uploadFile.getOriginalFilename();

			UUID uuid = UUID.randomUUID();

			String extension = FilenameUtils.getExtension(fileName);
			String savingFileName = uuid + "." + extension;

			String FilePath = pathName + File.separator + savingFileName;
			Path path = Paths.get(FilePath).toAbsolutePath();
			uploadFile.transferTo(path.toFile());

			/** 현재 사용자 정보를 가져와서 id로 조회를 한다.**/
			Long id = Long.valueOf(SecurityUtil.getCurrentId().get());
			Optional<UserEntity> user = userRepository.findById(id);
			user.get().setProfileImagePath(uploadFolder + "/" + savingFileName);
			userRepository.save(user.get());
			return ProfileDto.toDto(user.get());
		} catch (RuntimeException | IOException e) {
			e.printStackTrace();
			throw new CustomException(ErrorCode.UNKNOWN_ERROR);
		}
	}


	/**
	 * 독기풀
	 */
	public String getDokki(long userId) {
		return null;
	}


	public List<UserSimpleInfoDto> getUserSimpleforReview(List<Long> userIdList) {
		try {
			List<UserSimpleInfoDto> userSimpleInfoDtoList = new ArrayList<>();
			for (Long l : userIdList) {
				Optional<UserSimpleInfoDto> userSimpleInfoDto = userRepository.findById(l).map(
					userEntity -> getUserSimpleInfoDto(userEntity)
				);
				userSimpleInfoDtoList.add(userSimpleInfoDto.get());
			}
			return userSimpleInfoDtoList;
		} catch (RuntimeException e) {
			e.printStackTrace();
			throw new CustomException(ErrorCode.UNKNOWN_ERROR);
		}
	}


	public Optional<UserSimpleInfoDto> getAuth() {
		try {
			Long id = Long.valueOf(SecurityUtil.getCurrentId().get());
			Optional<UserSimpleInfoDto> userSimpleInfoDto = userRepository.findById(id).map(
				userEntity -> getUserSimpleInfoDto(userEntity)
			);
			return userSimpleInfoDto;
		} catch (RuntimeException e) {
			e.printStackTrace();
			throw new CustomException(ErrorCode.UNKNOWN_ERROR);
		}
	}


	public ProfileResponseDto getUserInfo() {
		try {
			Long id = Long.valueOf(SecurityUtil.getCurrentId().get());
			int followerCount = followRepository.countByToUserId(id);
			int followingCount = followRepository.countByFromUserId(id);
			Optional<ProfileResponseDto> profileResponseDto = userRepository.findById(id).map(
				userEntity -> getProfileResponseDto(followerCount, followingCount, userEntity)
			);
			return profileResponseDto.get();
		} catch (RuntimeException e) {
			e.printStackTrace();
			throw new CustomException(ErrorCode.UNKNOWN_ERROR);
		}
	}


	private UserSimpleInfoDto getUserSimpleInfoDto(UserEntity userEntity) {
		return UserSimpleInfoDto.builder()
			.profileImagePath(FileUtils.getAbsoluteFilePath(userEntity.getProfileImagePath()))
			.userId(userEntity.getId())
			.nickname(userEntity.getNickname())
			.build();
	}


	private ProfileResponseDto getProfileResponseDto(int followerCount, int followingCount, UserEntity userEntity) {
		return ProfileResponseDto.builder()
			.profileImagePath(FileUtils.getAbsoluteFilePath(userEntity.getProfileImagePath()))
			.userId(userEntity.getId())
			.nickname(userEntity.getNickname())
			.followerCount(followerCount)
			.followingCount(followingCount)
			.build();
	}
}
