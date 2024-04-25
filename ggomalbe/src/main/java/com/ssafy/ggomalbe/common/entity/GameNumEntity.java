package com.ssafy.ggomalbe.common.entity;


import lombok.Builder;
import lombok.Data;
import org.springframework.data.annotation.Id;
import org.springframework.data.relational.core.mapping.Column;
import org.springframework.data.relational.core.mapping.Table;

@Table("game_num")
@Builder
@Data
public class GameNumEntity extends AbstractEntity {
    @Id
    @Column("game_num_id")
    private final Long gameNumId;
}
