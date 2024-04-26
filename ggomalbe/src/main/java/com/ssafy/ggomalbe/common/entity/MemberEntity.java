package com.ssafy.ggomalbe.common.entity;

import lombok.Builder;
import lombok.Data;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import org.springframework.data.annotation.Id;
import org.springframework.data.relational.core.mapping.Column;
import org.springframework.data.relational.core.mapping.Table;

@Data
@Table("member")
@Builder
public class MemberEntity extends AbstractEntity {
    @Id
    @Column(value = "member_id")
    private final Long memberId;

    @Column(value = "center_id")
    private final Long centerId;

    private final String user;

    private final String password;

    private final String name;

    private final String phone;

    private final MemberEntity.Role role;

    @Getter
    @RequiredArgsConstructor
    public enum Role {
        TEACHER("선생님"), KID("아이"), CENTER("센터");

        private final String description;
    }
}
