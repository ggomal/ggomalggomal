package com.ssafy.ggomalbe.member.kid.dto;

import com.ssafy.ggomalbe.common.entity.KidEntity;
import com.ssafy.ggomalbe.common.entity.MemberEntity;
import com.ssafy.ggomalbe.common.entity.TeacherKidEntity;
import com.ssafy.ggomalbe.common.util.TokenGenerator;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

@Getter
@ToString
public class KidSignUpRequest {
    private String name;
    private String phone;
    private String img;
    private LocalDate kidBirthDT;
    private String kidNote;
    private String parentName;

    @Setter
    private Long teacherId;
    @Setter
    private Long centerId;
    @Setter
    private Long memberId;
    @Setter
    private String kidImgUrl;
    public MemberEntity toMemberEntity(){
        return MemberEntity.builder()
                .name(name)
                .centerId(centerId)
                .user(centerId.toString() + TokenGenerator.randomCharacterWithPrefix("stu"))
                .password(kidBirthDT.format(DateTimeFormatter.ofPattern("yyyyMMdd")))
                .phone(phone)
                .role(MemberEntity.Role.KID)
                .build();
    }

    public KidEntity toKidEntity(){
        return KidEntity.builder()
                .memberId(memberId)
                .kidImgUrl(kidImgUrl==null? "noImg":kidImgUrl)
                .kidBirthDT(kidBirthDT)
                .kidNote(kidNote)
                .parentName(parentName)
                .build();
    }

    public TeacherKidEntity toTeacherKidEntity(){
        return TeacherKidEntity.builder()
                .teacherId(teacherId)
                .kidId(memberId)
                .build();
    }
}
