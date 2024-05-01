package com.ssafy.ggomalbe.member.kid;

import com.ssafy.ggomalbe.common.entity.KidEntity;
import com.ssafy.ggomalbe.common.entity.MemberEntity;
import com.ssafy.ggomalbe.member.kid.dto.KidResponse;
import com.ssafy.ggomalbe.member.kid.dto.MemberKidResponse;

import java.time.LocalDate;
import java.time.Period;

public class KidMapper {

    public static MemberKidResponse toMemberKidResponse(MemberEntity member, KidEntity kid){
        return MemberKidResponse.builder()
                .memberId(member.getMemberId())
                .id(member.getUser())
                .password(member.getPassword())
                .name(member.getName())
                .parentPhone(member.getPhone())
                .kid()
                .build();
    }
}
