package com.dokki.user.dto.response;

import com.dokki.user.dto.ProfileDto;
import lombok.*;

@Getter
@Setter
@Builder
@AllArgsConstructor
@NoArgsConstructor
@ToString
public class KakaoInfoResponseDto {
    private long id;
    private ProfileDto kakao_account;
}
