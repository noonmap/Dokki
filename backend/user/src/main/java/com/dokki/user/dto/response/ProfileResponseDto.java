package com.dokki.user.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class ProfileResponseDto {
    private long userId;
    private String nickname;
    private String profileImagePath;
    private int followingCount;
    private int followerCount;
    private boolean isFollowed;
}
