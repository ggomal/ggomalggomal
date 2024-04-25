package com.ssafy.ggomalbe.common.entity;


import lombok.Builder;
import lombok.Data;
import org.springframework.data.annotation.Id;
import org.springframework.data.relational.core.mapping.Column;
import org.springframework.data.relational.core.mapping.Table;

@Table("chick_record")
@Builder
@Data
public class ChickRecordEntity extends AbstractEntity {
    @Id
    @Column("chick_record_id")
    private final Long chickRecordId;

    @Column("member_id")
    private final Long memberId;

    @Column("game_num")
    private final Long gameNum;
    private final String pronunciation;
    private final Float score;
}
