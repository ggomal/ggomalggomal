package com.ssafy.ggomalbe.member.kid.dto;

import lombok.Builder;
import lombok.Getter;

import java.time.LocalDate;

@Getter
@Builder
public class KidListResponse {

    private Long memberId;
    private String name;
//    private Integer age;
    private LocalDate kidBirthDT;
    private String id;
    private String password;
}
