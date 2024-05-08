package com.ssafy.ggomalbe.chick.service;

import com.ssafy.ggomalbe.chick.dto.ChickListResponse;
import com.ssafy.ggomalbe.common.entity.SituationKidEntity;
import com.ssafy.ggomalbe.common.repository.ChickRecognitionRepository;
import com.ssafy.ggomalbe.common.repository.SituationKidRepository;
import com.ssafy.ggomalbe.common.repository.SituationRepository;
import com.ssafy.ggomalbe.common.service.EvaluationService;
import com.ssafy.ggomalbe.common.service.NaverCloudClient;
import com.ssafy.ggomalbe.common.service.OpenApiClient;
import com.ssafy.ggomalbe.common.entity.ChickRecordEntity;
import com.ssafy.ggomalbe.common.repository.ChickRecordRepository;
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
@RequiredArgsConstructor
@Slf4j
public class ChickRecordServiceImpl implements ChickRecordService{
    private final ChickRecordRepository chickRecordRepository;
    private final EvaluationService evaluationService;
    private final SituationRepository situationRepository;
    private final SituationKidRepository situationKidRepository;
    private final ChickRecognitionRepository chickRecognitionRepository;

    @Override
    public Mono<Boolean> checkSentence(FilePart filePart, String sentence) {
        return evaluationService.toText(filePart)
                .flatMap(stt -> chickRecognitionRepository.existsByOriginTextAndRecognitionScope(sentence, stt));
        //우리의 기준대로 맞고 틀리고
        //넣어 -> 넣어, 너, 너어, 느어,
        //치워 -> 치워, 치어, 쳐, 츠어

        //햄 넣어 -> 햄버거
        //response { isPass : false, word:["넣","어"] }


        //정답 : 햄 넣어 : ["햄", "넣", "어"]
        //발음 : "햄어"

//                    햄 넣어
//                    피자 넣어
//                    고기 넣어
//                    버섯 넣어
//                    토마토 넣어
//                    올리브 넣어


//                    이불 치워
//                    돌 치워
//                    물 치워
//                    안경 치워
//      이건 DB에 넣죠
    }

    @Override
    public Mono<ChickRecordEntity> addChickRecord(FilePart filePart, Long memberId, Long gameNum, String sentence) {
        return evaluationService.evaluation(filePart, sentence)
                .doOnNext(System.out::println)
                .flatMap((evaluateResult) -> {
                    float score = evaluateResult.getScore();
                    String pronunciation = evaluateResult.getPronunciation();

                    ChickRecordEntity chickRecordEntity = ChickRecordEntity.builder()
                            .memberId(memberId)
                            .gameNum(gameNum)
                            .pronunciation(pronunciation)
                            .score(score)
                            .build();
                    return chickRecordRepository.save(chickRecordEntity);
                }).doOnNext(data -> log.info("save {}", data.toString()));
    }

    @Override
    public Flux<ChickListResponse> getSituationList(Long memberId) {
        return situationRepository.getOwnSituationList(memberId);
    }

    @Override
    public Mono<Boolean> getNextSituation(Long memberId, Long situationId) {
        return situationRepository.count()
                .flatMap(max -> {
                    // ** 마지막 병아리가 아닌데 이미 잠금 해제 했을 경우 -> 다음 거 이미 열려있는 경우 그냥 처리 안하고 넘겨 줘야함
                    if (situationId >= max) {   // 마지막 병아리일 경우
                        return Mono.just(false);
                    } else {
                        SituationKidEntity entity = SituationKidEntity.builder()
                                .situationId(situationId+1)
                                .memberId(memberId)
                                .build();

                        return situationKidRepository.existsByMemberIdAndSituationId(memberId, situationId + 1)
                                .flatMap(flag -> {
                                    if (!flag)
                                        return situationKidRepository.save(entity)
                                                .map(result -> result.getSituationKidId() != null);
                                    else
                                        return Mono.just(false);
                                });
                    }
                });
    }


    @Override
    public Mono<Boolean> setChickGameRecord(ChickRecordEntity entity) {
        return chickRecordRepository.save(entity)
                .map(saveEntity -> saveEntity.getChickRecordId() != null);
    }


//    public Mono<Void> isPass(FilePart filePart, String sentence) {
//        return filePart
//                .content()
//                .flatMapSequential(dataBuffer -> Flux.fromIterable(dataBuffer::readableByteBuffers))
//                .reduce((b1, b2) -> {
//                    b1.put(b2);
//                    return b1;
//                })
//                .flatMap(buffer -> naverCloudClient.soundToText(buffer))
//                .doOnNext(n->log.info("{}",n)).then();
//    }
}
