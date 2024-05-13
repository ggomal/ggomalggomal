package com.ssafy.ggomalbe.common.entity;

import lombok.Builder;
import lombok.Data;
import org.springframework.data.annotation.Id;
import org.springframework.data.relational.core.mapping.Column;
import org.springframework.data.relational.core.mapping.Table;

@Table("whale_record")
@Builder
@Data
public class WhaleRecordEntity extends AbstractEntity {

    @Id
    @Column("whale_record_id")
    private Long whaleRecordId;

    @Column("member_id")
    private final Long memberId;

    @Column("max_time")
    private final Float maxTime;
}
