package com.ssafy.ggomalbe.furniture.dto;

import lombok.Builder;
import lombok.Getter;
import lombok.ToString;

@Getter
@ToString
@Builder
public class FurnitureAddResponse {
    private String name;

    public FurnitureAddResponse(String furniture){
        this.name = furniture;
    }

}
