package com.ssafy.ggomalbe.whale.dto;

import lombok.Builder;
import lombok.Data;

import java.util.List;

@Data
@Builder
public class WhaleEvaluationDto {
    private String refSentence;
    private Boolean allResult;
    private List<Boolean> wordResult;
    private List<WordScore> wordScores;

    private Long memberId;
    private Long gameNum;
    private Float score;

}
