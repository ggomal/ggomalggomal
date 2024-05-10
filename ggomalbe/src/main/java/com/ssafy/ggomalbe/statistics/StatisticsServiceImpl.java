package com.ssafy.ggomalbe.statistics;

import com.ssafy.ggomalbe.common.repository.WhaleRecordRepository;
import com.ssafy.ggomalbe.statistics.dto.StatisticResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import reactor.core.publisher.Mono;

@Service
@RequiredArgsConstructor
public class StatisticsServiceImpl implements StatisticsService{
    private final WhaleRecordRepository whaleRecordRepository;
    @Override
    public Mono<StatisticResponse> getStatistic(Long kidId) {
        return whaleRecordRepository.findByKidIdWithMean(kidId)
                .collectList()
                .map( whaleStatisticResults -> StatisticResponse.builder()
                        .whaleMaxTime(whaleStatisticResults).build());
    }
}
