package com.ssafy.ggomalbe.common.entity;


import lombok.Builder;
import lombok.Data;
import org.springframework.data.annotation.Id;
import org.springframework.data.relational.core.mapping.Column;
import org.springframework.data.relational.core.mapping.Table;

@Table("frog_record")
@Builder
@Data
public class FrogRecordEntity extends AbstractEntity {
    @Id
    @Column("frog_record_id")
    private final Long frogRecordId;

    @Column("member_id")
    private final Long memberId;

    @Column("duration_sec")
    private final Float durationSec;

    private final Float length;
}
