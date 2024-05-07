package com.ssafy.ggomalbe.bear.service;

import com.ssafy.ggomalbe.bear.dto.BearRecordResponse;
import com.ssafy.ggomalbe.common.entity.BearRecordEntity;
import com.ssafy.ggomalbe.common.repository.BearRecordRepository;
import com.ssafy.ggomalbe.common.service.EvaluationService;
import com.ssafy.ggomalbe.common.service.NaverCloudClient;
import com.ssafy.ggomalbe.common.service.OpenApiClient;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.codec.multipart.FilePart;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

import java.util.HashMap;
import java.util.Map;

@Service
@Transactional
@Slf4j
@RequiredArgsConstructor
public class BearRecordServiceImpl implements BearRecordService {
    private final BearRecordRepository bearRecordRepository;
    private final EvaluationService evaluationService;

    //특정 멤버 기록 조회 후 날짜별로 정렬(게임 아이디로 정렬)
    public Flux<BearRecordEntity> getBearRecords(Long id) {
        return bearRecordRepository.findByMemberId(id);
    }


    @Override
    public Mono<BearRecordResponse> addBearRecord(FilePart filePart, Long memberId, Long gameNum, Long wordId, String letter, Short pronCount) {
        return evaluationService.evaluation(filePart, letter)
                .flatMap((evaluateResult) -> {
                    float score =evaluateResult.getScore();
                    String pronunciation = evaluateResult.getPronunciation();

                    BearRecordEntity bearRecordEntity = BearRecordEntity.builder()
                            .memberId(memberId)
                            .wordId(wordId)
                            .gameNum(gameNum)
                            .pronunciation(pronunciation)
                            .pronCount(pronCount)
                            .score(score)
                            .build();
                    return bearRecordRepository.save(bearRecordEntity);
                })
                .map(result->{
                    return BearRecordResponse.builder()
                            .bearRecordId(result.getBearRecordId())
                            .memberId(result.getMemberId())
                            .wordId(result.getWordId())
                            .gameNum(result.getGameNum())
                            .pronunciation(result.getPronunciation())
                            .pronCount(result.getPronCount())
                            .score(result.getScore())
                            .build();
                })
                .doOnNext(result -> log.info("save {}", result.toString()));
    }
}
