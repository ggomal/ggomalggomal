package com.ssafy.ggomalbe.member.login.dto;

import com.ssafy.ggomalbe.common.entity.MemberEntity;
import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class LoginResponse {
    private final String msg;
    private final String jwt;
    private final MemberEntity.Role role;
}
