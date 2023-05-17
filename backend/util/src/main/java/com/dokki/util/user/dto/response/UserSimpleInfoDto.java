package com.dokki.util.user.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class UserSimpleInfoDto {
    private long userId;
    private String nickname;
    private String profileImagePath;
}
