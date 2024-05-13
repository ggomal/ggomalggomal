package com.ssafy.ggomalbe.statistics;

import com.ssafy.ggomalbe.common.repository.BearRecordRepository;
import com.ssafy.ggomalbe.common.repository.ChickRecordRepository;
import com.ssafy.ggomalbe.common.repository.WhaleRecordRepository;
import com.ssafy.ggomalbe.statistics.dto.StatisticResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import reactor.core.publisher.Mono;

import java.util.Set;

@Service
@RequiredArgsConstructor
public class StatisticsServiceImpl implements StatisticsService {
    private final WhaleRecordRepository whaleRecordRepository;
    private final BearRecordRepository bearRecordRepository;
    private final ChickRecordRepository chickRecordRepository;

    @Override
    public Mono<StatisticResponse> getStatistic(Long kidId) {
        return Mono.just(new StatisticResponse())
                .flatMap(statisticResponse -> whaleRecordRepository.findByKidIdWithMean(kidId)
                        .collectList()
                        .map(whaleStatisticResults -> {
                            statisticResponse.setWhaleMaxTime(whaleStatisticResults);
                            return statisticResponse;
                        }))
                .flatMap(res -> addInitial(kidId, "ㄹ", res))
                .flatMap(res -> addInitial(kidId, "ㅅ", res))
                .flatMap(res -> addInitial(kidId, "ㄱ, ㅋ, ㅈ, ㅊ", res))
                .flatMap(res -> addInitial(kidId, "ㄷ, ㅌ, ㄴ", res))
                .flatMap(res -> addInitial(kidId, "ㅍ, ㅁ, ㅇ", res))
                .flatMap(statisticResponse -> bearRecordRepository.findMostUsedByKidId(kidId)
                        .collectList()
                        .map(wordMostResults -> {
                            statisticResponse.setMostUsedWord(wordMostResults);
                            return statisticResponse;
                        }))
                .flatMap(statisticResponse -> chickRecordRepository.findAccuracyDateByKidId(kidId)
                        .collectList()
                        .map(chickAccuracyResults -> {
                            statisticResponse.setChickAccuracy(chickAccuracyResults);
                            return statisticResponse;
                        }))
                ;

    }

    private Mono<StatisticResponse> addInitial(Long kidId, String initial, StatisticResponse res){
        return bearRecordRepository.findAccuracyDateByKidIdAndInitial(kidId, Set.of(initial.split(", ")))
                .collectList()
                .map(wordAccuracyResults -> {
                    if (wordAccuracyResults.isEmpty()) return res;
                    res.getWordAccuracy().put(initial, wordAccuracyResults);
                    res.putWordAccuracyMean(initial, wordAccuracyResults);
                    return res;
                });
    }
}
