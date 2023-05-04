package com.dokki.user.service;

import com.dokki.user.dto.request.ProfileRequestDto;
import com.dokki.user.dto.response.ProfileResponseDto;
import com.dokki.user.dto.response.UserResponseDto;
import com.dokki.user.entity.UserEntity;
import com.dokki.user.repository.UserRepository;
import com.dokki.user.security.SecurityUtil;
import com.dokki.util.user.dto.response.UserSimpleInfoDto;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.catalina.User;
import org.apache.commons.io.FilenameUtils;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Slice;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
@Slf4j
@RequiredArgsConstructor
public class UserService {
    private final UserRepository userRepository;

    @Value("${app.fileupload.uploadPath}")
    String uploadPath;
    @Value("${app.fileupload.uploadDir}")
    String uploadFolder;

    /**
     * 사용자 검색
     *     private String search;
     *     private int page;
     *     private int size;
     */
    public Slice<UserSimpleInfoDto> getUserList(ProfileRequestDto profileRequestDto) {
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
    }
    /**
     * 유저 프로필 정보 조회
     */
    public ProfileResponseDto getUserProfile(long userId) {
        Optional<ProfileResponseDto> profileResponseDto = userRepository.findById(userId).map(ProfileResponseDto::toDto);
        return profileResponseDto.get();
    }
    /**
     * 유저 닉네임 수정
     */
    public String modifyNickname(String nickname) {
        /** 현재 사용자 정보를 가져와서 id로 조회를 한다.**/
        Long id = Long.valueOf(SecurityUtil.getCurrentId().get());
        Optional<UserEntity> user = userRepository.findById(id);
        if(user.isPresent()){
            user.get().setNickname(nickname);
            userRepository.save(user.get());
            return "SUCCESS";
        }else{
            return "FAIL";
        }
    }
    /**
     * 유저 이미지 파일 수정
     */
    public String modifyImage(MultipartFile uploadFile){
        try{
            String pathName = uploadPath + File.separator + uploadFolder + File.separator;
            File uploadDir = new File(pathName);
            if(!uploadDir.exists()) uploadDir.mkdir();

            String fileName = uploadFile.getOriginalFilename();

            UUID uuid = UUID.randomUUID();

            String extension = FilenameUtils.getExtension(fileName);
            String savingFileName = uuid+"."+extension;

            String FilePath = pathName+File.separator+savingFileName;
            Path path = Paths.get(FilePath).toAbsolutePath();
            uploadFile.transferTo(path.toFile());

            /** 현재 사용자 정보를 가져와서 id로 조회를 한다.**/
            Long id = Long.valueOf(SecurityUtil.getCurrentId().get());
            Optional<UserEntity> user = userRepository.findById(id);
            user.get().setProfileImagePath(uploadFolder + "/" + savingFileName);
            userRepository.save(user.get());
            return "SUCCESS";
        }catch (IOException e){
            e.printStackTrace();
            return "FAIL";
        }
    }
    /**
     * 독기풀
     */
    public String getDokki(long userId) {
        return null;
    }

    public List<UserSimpleInfoDto> getUserSimpleforReview(List<Long> userIdList) {
        List<UserSimpleInfoDto> userSimpleInfoDtoList = new ArrayList<>();
        for(Long l : userIdList){
            Optional<UserSimpleInfoDto> userSimpleInfoDto  = userRepository.findById(l).map(
                    userEntity -> UserSimpleInfoDto.builder()
                            .profileImagePath(userEntity.getProfileImagePath())
                            .userId(userEntity.getId())
                            .nickname(userEntity.getNickname())
                            .build()
            );
            userSimpleInfoDtoList.add(userSimpleInfoDto.get());
        }

        return userSimpleInfoDtoList;
    }

    public Optional<UserSimpleInfoDto> getAuth() {
        Long id = Long.valueOf(SecurityUtil.getCurrentId().get());
        Optional<UserSimpleInfoDto> userSimpleInfoDto = userRepository.findById(id).map(
                userEntity -> UserSimpleInfoDto.builder()
                        .profileImagePath(userEntity.getProfileImagePath())
                        .userId(userEntity.getId())
                        .nickname(userEntity.getNickname())
                        .build()
        );
        return userSimpleInfoDto;
    }
}
