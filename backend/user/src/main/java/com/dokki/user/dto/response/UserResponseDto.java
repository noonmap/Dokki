package com.dokki.user.dto.response;

import com.dokki.user.dto.TokenDto;
import com.dokki.user.dto.UserDto;
import lombok.*;

@Getter
@Setter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class UserResponseDto {
    private TokenDto tokenDto;
    private UserDto userDto;
}

