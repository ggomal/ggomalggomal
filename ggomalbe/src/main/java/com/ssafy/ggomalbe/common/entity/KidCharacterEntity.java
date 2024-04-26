package com.ssafy.ggomalbe.common.entity;


import lombok.Builder;
import lombok.Data;
import org.springframework.data.annotation.Id;
import org.springframework.data.relational.core.mapping.Column;
import org.springframework.data.relational.core.mapping.Table;

@Table("kid_character")
@Builder
@Data
public class KidCharacterEntity extends AbstractEntity {
    @Id
    @Column("kid_character_id")
    private final Long kidCharacterId;

    @Column("member_id")
    private final Long memberId;

    @Column("character_id")
    private final Long characterId;

    private final Long exp;
}
