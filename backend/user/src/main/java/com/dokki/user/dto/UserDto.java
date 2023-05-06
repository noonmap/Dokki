package com.dokki.user.dto;

import lombok.*;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class UserDto {
    private String username;
    private String userId;
    private String email;
    private String nickname;
    private String profileImageUrl;
    private String providerId;
}
