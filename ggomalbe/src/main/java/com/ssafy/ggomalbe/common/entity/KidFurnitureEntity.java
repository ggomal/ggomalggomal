package com.ssafy.ggomalbe.common.entity;


import lombok.Builder;
import lombok.Data;
import lombok.Getter;
import org.springframework.data.annotation.Id;
import org.springframework.data.relational.core.mapping.Column;
import org.springframework.data.relational.core.mapping.Table;

@Table("kid_furniture")
@Getter
@Builder
public class KidFurnitureEntity extends AbstractEntity {
    @Id
    @Column("kid_furniture_id")
    private final Long kidFurnitureId;

    @Column("member_id")
    private final Long memberId;

    @Column("furniture_id")
    private final Long furnitureId;

//    public static KidFurnitureEntity toEntity(Long furnitureId, Long memberId){
//        return KidFurnitureEntity.builder()
//                .furnitureId(furnitureId)
//                .memberId(memberId)
//                .build();
//    }
}
