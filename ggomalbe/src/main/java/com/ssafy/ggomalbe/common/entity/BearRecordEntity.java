package com.ssafy.ggomalbe.common.entity;


import lombok.Builder;
import lombok.Data;
import lombok.EqualsAndHashCode;
import org.springframework.data.annotation.Id;
import org.springframework.data.relational.core.mapping.Column;
import org.springframework.data.relational.core.mapping.Table;

@Table("bear_record")
@Builder
@Data
public class BearRecordEntity extends AbstractEntity {
    @Id
    @Column("bear_record_id")
    private final Long bearRecordId;
    
    @Column("member_id")
    private final Long memberId;

    @Column("word_id")
    private final Long wordId;

    private final Long gameNum;

    private final String pronunciation;

    private final Short pronCount;

    private final Float score;

}
