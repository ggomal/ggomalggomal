package com.ssafy.ggomalbe.common.entity;


import lombok.Builder;
import lombok.Data;
import org.springframework.data.annotation.Id;
import org.springframework.data.relational.core.mapping.Column;
import org.springframework.data.relational.core.mapping.Table;

@Table("character")
@Builder
@Data
public class CharacterEntity extends AbstractEntity {
    @Id
    @Column("character_id")
    private final Long characterId;

    @Column("character_name")
    private final String characterName;
}
