package com.dokki.user.dto;

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

}
