package com.ssafy.ggomalbe.member.kid.dto;

import com.ssafy.ggomalbe.common.entity.MemberEntity;
import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class KidSignUpResponse {
    private Long kidId;
    private Long centerId;
    private String id;
    private String password;
    private String name;
    private String phone;
    private MemberEntity.Role role;
    private String kidNote;
}
