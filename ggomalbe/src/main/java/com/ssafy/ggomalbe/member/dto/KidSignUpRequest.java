package com.ssafy.ggomalbe.member.dto;

import lombok.Getter;
import lombok.ToString;

import java.time.LocalDateTime;

@Getter
@ToString
public class KidSignUpRequest {
    private String name;
    private String phone;
    private String img;
    private LocalDateTime kidBirthDT;
    private String kidNote;
    private String parentName;
}
