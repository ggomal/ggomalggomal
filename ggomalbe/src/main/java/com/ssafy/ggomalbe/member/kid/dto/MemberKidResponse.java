package com.ssafy.ggomalbe.member.kid.dto;

import com.ssafy.ggomalbe.common.entity.KidEntity;
import lombok.Builder;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

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

    private KidResponse kidResponse;

    public void setKidResponse(KidEntity kid) {
        this.kidResponse.setKidResponse(kid);
    }
}
