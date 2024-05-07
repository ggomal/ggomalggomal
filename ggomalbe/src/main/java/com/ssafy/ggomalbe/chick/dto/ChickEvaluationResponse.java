package com.ssafy.ggomalbe.chick.dto;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class ChickEvaluationResponse {
    private String msg;
    private Boolean result;
}
