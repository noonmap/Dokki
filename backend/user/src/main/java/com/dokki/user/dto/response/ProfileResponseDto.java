package com.dokki.user.dto.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.databind.ObjectMapper;
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

}
