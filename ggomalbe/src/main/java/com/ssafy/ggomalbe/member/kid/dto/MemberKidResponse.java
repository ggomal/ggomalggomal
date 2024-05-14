package com.ssafy.ggomalbe.member.kid.dto;

import com.ssafy.ggomalbe.common.entity.KidEntity;
import lombok.Builder;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.time.LocalDate;
import java.time.Period;

@Getter
@ToString
@Builder
public class MemberKidResponse {
    private Long memberId;
    private String id;  // user(로그인 아이디)
    private String password;
    private String name;
    private String parentPhone; // phone(연락처)

    private KidEntity.Gender gender;

    private String kidImgUrl;
//    private LocalDate kidBirthDT;
    private Integer age;    // kidBirthDT(생년월일)로 계산 -> 시간관련 함수 포함한 Query로 가져오기
    private String kidNote; // 특이사항
    private String parentName;

//    public void setAge(LocalDate kidBirthDT){
//        this.age = Period.between(kidBirthDT, LocalDate.now()).getYears();
//    }
}
