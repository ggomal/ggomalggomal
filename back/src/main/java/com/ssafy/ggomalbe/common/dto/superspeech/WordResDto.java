package com.ssafy.ggomalbe.common.dto.superspeech;

import lombok.Data;

@Data
public class WordResDto {
    private int readType;
    private ScoreResDto scores;
    private String word;
}