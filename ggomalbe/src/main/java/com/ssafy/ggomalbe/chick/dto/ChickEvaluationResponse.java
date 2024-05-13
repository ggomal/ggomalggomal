package com.ssafy.ggomalbe.chick.dto;

import lombok.Builder;
import lombok.Data;

import java.util.List;

@Data
@Builder
public class ChickEvaluationResponse {
    private String refWord;
    private Boolean overResult;
    private List<Boolean> words;
}
