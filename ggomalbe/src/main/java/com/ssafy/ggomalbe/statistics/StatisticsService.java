package com.ssafy.ggomalbe.statistics;

import com.ssafy.ggomalbe.statistics.dto.StatisticResponse;
import reactor.core.publisher.Mono;

public interface StatisticsService {

    // < 학습 현황 >
    // 음소별 정확도 평균 점수
    // 음소별 정확도 변화 그래프
    // 고래게임 최대 발성 길이 변화 그래프
    // 빙고에서 많이 말한 단어 랭킹
    // 병아리 게임에서 측정한 정확도 변화
    Mono<StatisticResponse> getStatistic(Long kidId);
}
