package com.ssafy.ggomalbe.common.entity;


import lombok.Builder;
import lombok.Data;
import org.springframework.data.annotation.Id;
import org.springframework.data.relational.core.mapping.Column;
import org.springframework.data.relational.core.mapping.Table;

@Table("kid_character")
@Builder
@Data
public class KidFurnitureEntity extends AbstractEntity {
    @Id
    @Column("kid_furniture_id")
    private final Long kidCharacterId;

    @Column("member_id")
    private final Long memberId;

    @Column("furniture_id")
    private final Long characterId;
}
