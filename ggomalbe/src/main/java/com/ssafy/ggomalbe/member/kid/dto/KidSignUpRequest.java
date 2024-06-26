package com.ssafy.ggomalbe.member.kid.dto;

import com.ssafy.ggomalbe.common.entity.KidEntity;
import com.ssafy.ggomalbe.common.entity.MemberEntity;
import com.ssafy.ggomalbe.common.entity.TeacherKidEntity;
import com.ssafy.ggomalbe.common.util.TokenGenerator;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
import org.springframework.util.StringUtils;

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
    private KidEntity.Gender gender;

    @Setter
    private Long teacherId;
    @Setter
    private Long centerId;
    @Setter
    private Long memberId;
    @Setter
    private String kidImgUrl;

    private String user;

    public void setUser(){
        if (!StringUtils.hasLength(user)) user = centerId.toString() + TokenGenerator.randomCharacterWithPrefix("stu");
    }

    public MemberEntity toMemberEntity(){
        return MemberEntity.builder()
                .name(name)
                .centerId(centerId)
                .user(user)
                .password(kidBirthDT.format(DateTimeFormatter.ofPattern("yyyyMMdd")))
                .phone(phone)
                .role(MemberEntity.Role.KID)
                .build();
    }

    public KidEntity toKidEntity(){
        return KidEntity.builder()
                .memberId(memberId)
//                .kidImgUrl(kidImgUrl==null? "https://ggomalggomal.s3.ap-southeast-2.amazonaws.com/userImg/noImg":kidImgUrl)
                .kidImgUrl(gender.toString().equals("MALE")? "https://ggomalggomal.s3.ap-southeast-2.amazonaws.com/userImg/male":"https://ggomalggomal.s3.ap-southeast-2.amazonaws.com/userImg/female")
                .kidBirthDT(kidBirthDT)
                .kidNote(kidNote)
                .parentName(parentName)
                .gender(gender)
                .coin(0L)
                .build();
    }

    public TeacherKidEntity toTeacherKidEntity(){
        return TeacherKidEntity.builder()
                .teacherId(teacherId)
                .kidId(memberId)
                .build();
    }

    public KidSignUpResponse toKidSignUpResponse(){
        return KidSignUpResponse.builder()
                .kidId(memberId)
                .centerId(centerId)
                .id(user)
                .password(kidBirthDT.format(DateTimeFormatter.ofPattern("yyyyMMdd")))
                .name(name)
                .phone(phone)
                .role(MemberEntity.Role.KID)
                .kidNote(kidNote)
                .gender(gender)
                .build();
    }
}
