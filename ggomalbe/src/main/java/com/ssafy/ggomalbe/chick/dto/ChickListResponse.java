package com.ssafy.ggomalbe.chick.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
@AllArgsConstructor
public class ChickListResponse {
    private Long id;
    private String title;
    private Boolean acquired;
}
