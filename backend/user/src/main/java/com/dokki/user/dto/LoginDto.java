package com.dokki.user.dto;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Notnull;
import javax.validation.constraints.Size;

import lombok.*;
@Getter
@Setter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class LoginDto {

    @NotNull
    @Size(min=1, max=50)
    private String email;

    @NotNull
    @Size(min=3, max=100)
    private String provider;

}
