package com.ssafy.ggomalbe.member.kid.dto;

import com.ssafy.ggomalbe.common.entity.KidEntity;
import lombok.Builder;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.time.LocalDate;

@Getter
@ToString
@Setter
@Builder
public class MemberKidResponse {
    private Long memberId;
    private String id;  // user(로그인 아이디)
    private String password;
    private String name;
    private String parentPhone; // phone(연락처)

    private String kidImgUrl;
    //    private int age;    // kidBirthDT(생년월일)로 계산
    private LocalDate kidBirthDT;
    private String kidNote; // 특이사항
    private String parentName;

}
