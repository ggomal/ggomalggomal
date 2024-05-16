package com.ssafy.ggomalbe.whale.dto;

import lombok.Builder;
import lombok.Data;

import java.util.List;

@Data
@Builder
public class WhaleEvaluationResponse {
    private String refSentence;
    private Boolean allResult;
    private List<Boolean> wordResult;

}
