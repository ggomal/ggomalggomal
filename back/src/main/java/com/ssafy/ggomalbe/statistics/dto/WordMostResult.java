package com.ssafy.ggomalbe.statistics.dto;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class WordMostResult {
    private String word;
    private Integer count;
}
