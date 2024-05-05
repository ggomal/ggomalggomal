package com.ssafy.ggomalbe.common.entity;


import lombok.Builder;
import lombok.Data;
import org.springframework.data.annotation.Id;
import org.springframework.data.relational.core.mapping.Column;
import org.springframework.data.relational.core.mapping.Table;

@Table("furniture")
@Builder
@Data
public class FurnitureEntity extends AbstractEntity {
    @Id
    @Column("furniture_id")
    private final Long furnitureId;

    @Column("furniture_name")
    private final String furnitureName;
}
