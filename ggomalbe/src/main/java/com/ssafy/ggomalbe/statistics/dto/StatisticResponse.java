package com.ssafy.ggomalbe.statistics.dto;

import lombok.Data;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Data
public class StatisticResponse {
    // < 학습 현황 >
    // 음소별 정확도 평균 점수
    private Map<String, Float> wordAccuracyMean;
    // 음소별 정확도 변화 그래프
    private Map<String, List<WordAccuracyResult>> wordAccuracy;
    // 고래게임 최대 발성 길이 변화 그래프
    private List<WhaleStatisticResult> whaleMaxTime;
    // 빙고에서 많이 말한 단어 랭킹
    private List<WordMostResult> mostUsedWord;
    // 병아리 게임에서 측정한 정확도 변화
    private List<ChickAccuracyResult> chickAccuracy;

    public StatisticResponse() {
        this.wordAccuracyMean = new HashMap<>();
        this.wordAccuracy = new HashMap<>();
        this.whaleMaxTime = new ArrayList<>();
        this.mostUsedWord = new ArrayList<>();
        this.chickAccuracy = new ArrayList<>();
    }

    public void putWordAccuracyMean(String initial, List<WordAccuracyResult> lis){
        int denominator = lis.size();
        Float numerator = 0F;
        for (WordAccuracyResult wa:lis) numerator += wa.getAccuracyMean();
        wordAccuracyMean.put(initial, numerator / (denominator==0? 1:denominator));
    }
}
