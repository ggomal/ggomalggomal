package com.ssafy.ggomalbe.member.kid.dto;

import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Builder
public class KidResponse {
    private String kidImgUrl;
    private int age;    // kidBirthDT(생년월일)로 계산
    private String kidNote; // 특이사항
    private String parentName;

}
