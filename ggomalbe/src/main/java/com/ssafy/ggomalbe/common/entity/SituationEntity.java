package com.ssafy.ggomalbe.common.entity;

import lombok.Builder;
import lombok.Data;
import org.springframework.data.annotation.Id;
import org.springframework.data.relational.core.mapping.Column;
import org.springframework.data.relational.core.mapping.Table;

@Table("situation")
@Builder
@Data
public class SituationEntity extends AbstractEntity {
    @Id
    @Column("situation_id")
    private final Long situationId;

    @Column("situation_title")
    private final String situationTitle;
}
