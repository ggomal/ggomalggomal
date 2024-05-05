package com.ssafy.ggomalbe.furniture.dto;

import jdk.jfr.Unsigned;
import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class FurnitureListResponse {
    private Long id;
    private String name;
    private Boolean acquired;
}
