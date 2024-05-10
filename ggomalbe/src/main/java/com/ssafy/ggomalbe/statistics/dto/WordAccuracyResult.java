package com.ssafy.ggomalbe.statistics.dto;

import lombok.Builder;
import lombok.Data;

import java.util.List;

@Data
@Builder
public class WordAccuracyResult {
    private Float accuracyMean;
    private List<Float> accuracyList;
}
