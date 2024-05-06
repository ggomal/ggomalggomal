package com.ssafy.ggomalbe.common.entity;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.Getter;
import org.springframework.data.annotation.Id;
import org.springframework.data.relational.core.mapping.Column;
import org.springframework.data.relational.core.mapping.Table;

@Table("situation_kid")
@Getter
@AllArgsConstructor
@Builder
public class SituationKidEntity extends AbstractEntity {
    @Id
    @Column("situation_kid_id")
    private final Long situationKidId;

    @Column("member_id")
    private final Long memberId;

    @Column("situation_id")
    private final Long situationId;
}
