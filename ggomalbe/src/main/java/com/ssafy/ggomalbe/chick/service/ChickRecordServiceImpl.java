package com.ssafy.ggomalbe.chick.service;

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

    @Override
    public Mono<ChickRecordEntity> addChickRecord(FilePart filePart, Long memberId, Long gameNum, String sentence) {
        return evaluationService.evaluation(filePart, sentence)
                .flatMap((evaluateResult) -> {
                    float score = evaluateResult.getScore();
                    String pronunciation = evaluateResult.getPronunciation();

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



                    ChickRecordEntity chickRecordEntity = ChickRecordEntity.builder()
                            .memberId(memberId)
                            .gameNum(gameNum)
                            .pronunciation(pronunciation)
                            .score(score)
                            .build();
                    return chickRecordRepository.save(chickRecordEntity);
                }).doOnNext(data -> log.info("save {}", data.toString()));
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
