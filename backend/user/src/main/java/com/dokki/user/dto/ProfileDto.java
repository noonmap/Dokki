package com.dokki.user.dto;

import com.dokki.user.entity.UserEntity;
import com.dokki.util.common.utils.FileUtils;
import lombok.*;

@Getter
@Setter
@Builder
@AllArgsConstructor
@NoArgsConstructor
@ToString
public class ProfileDto {
    private String email;
    private String thumbnail_image_url;
    private String profile_image_url;
    public static ProfileDto toDto(UserEntity userEntity){
        return ProfileDto.builder()
                .email(userEntity.getEmail())
                .profile_image_url(FileUtils.getAbsoluteFilePath(userEntity.getProfileImagePath()))
                .thumbnail_image_url(FileUtils.getAbsoluteFilePath(userEntity.getProfileImagePath()))
                .build();
    }

}
