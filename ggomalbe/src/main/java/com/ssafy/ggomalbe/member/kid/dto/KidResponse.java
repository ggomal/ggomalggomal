package com.ssafy.ggomalbe.member.kid.dto;

import com.ssafy.ggomalbe.common.entity.KidEntity;
import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDate;
import java.time.Period;

@Getter
@Setter
@Builder
public class KidResponse {
    private String kidImgUrl;
    private int age;    // kidBirthDT(생년월일)로 계산
    private String kidNote; // 특이사항
    private String parentName;

    public KidResponse setKidResponse(KidEntity kid){
        this.kidImgUrl = kid.getKidImgUrl();
        this.age = Period.between(kid.getKidBirthDT(), LocalDate.now()).getYears();
        this.kidNote = kid.getKidNote();
        this.parentName = kid.getParentName();
        return this;
    }
}
