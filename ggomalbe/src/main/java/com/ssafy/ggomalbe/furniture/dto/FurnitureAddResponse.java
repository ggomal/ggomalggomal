package com.ssafy.ggomalbe.furniture.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.ToString;

@Getter
@ToString
@Builder
@AllArgsConstructor
public class FurnitureAddResponse {
    private Long furnitureId;
    private Boolean isDone;

    public FurnitureAddResponse(Long furnitureId){
        this.furnitureId = furnitureId;
        this.isDone = true;
    }

}
