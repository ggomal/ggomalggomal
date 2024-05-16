package com.ssafy.ggomalbe.member.kid.dto;

import com.ssafy.ggomalbe.common.entity.MemberEntity;
import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class MemberIdRoleDto {
    private Long memberId;
    private MemberEntity.Role memberRole;
}
