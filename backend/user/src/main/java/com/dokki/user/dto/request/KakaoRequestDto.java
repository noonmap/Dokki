package com.dokki.user.dto.request;

import lombok.*;

@Getter
@Setter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class KakaoRequestDto {
    private String grant_type;
    private String client_id;
    private String redirect_uri;
    private String code;

    @Override
    public String toString() {
        return
                "code=" + code + '&' +
                "client_id=" + client_id + '&' +
                "redirect_uri=" + redirect_uri + '&' +
                "grant_type=" + grant_type;
    }
}
