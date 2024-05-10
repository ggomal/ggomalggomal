package com.ssafy.ggomalbe.statistics.dto;

import lombok.Builder;
import lombok.Data;
import org.joda.time.LocalDate;

import java.util.List;
import java.util.Map;

@Data
@Builder
public class StatisticResponse {
    // < 학습 현황 >
    // 음소별 정확도 평균 점수
    private Float wordAccuracyMean;
    // 음소별 정확도 변화 그래프
    private Map<LocalDate, Float> wordAccuracy;
    // 고래게임 최대 발성 길이 변화 그래프
    private List<WhaleStatisticResult> whaleMaxTime;
    // 빙고에서 많이 말한 단어 랭킹
    private List<String> mostUsedWord;
    // 병아리 게임에서 측정한 정확도 변화
    private List<Float> chickAccuracy;
}
