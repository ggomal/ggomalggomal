package com.ssafy.ggomalbe.chick.service;

import com.ssafy.ggomalbe.bear.service.NaverCloudClient;
import com.ssafy.ggomalbe.bear.service.OpenApiClient;
import com.ssafy.ggomalbe.common.entity.BearRecordEntity;
import com.ssafy.ggomalbe.common.entity.ChickRecordEntity;
import com.ssafy.ggomalbe.common.repository.ChickRecordRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.codec.multipart.FilePart;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.RequestPart;
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
    private final NaverCloudClient naverCloudClient;
    private final OpenApiClient openApiClient;

    @Override
    public Mono<ChickRecordEntity> addChickRecord(FilePart filePart, Long memberId, Long gameNum, String sentence) {
        return evaluation(filePart, sentence)
                .flatMap((evaluateResult) -> {
                    float score = Float.parseFloat(evaluateResult.get("score"));
                    String pronunciation = evaluateResult.get("pronunciation");

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



    /**
     * 평가데이터 저장
     * @param sentence : 말해야 하는 정답 단어
     * @param filePart : 아이가 단어를 읽고 녹음한 데이터
     * @return
     * score: letter와 아이의 음성을 비교하여 도출한 점수
     * stt: 아이의 음성을 텍스트로 변환한 문자열
     * letter : 아이가 말해야하는 정답 단어
     */
    public Mono<Map<String, String>> evaluation(FilePart filePart, String sentence) {
        return filePart.content()
                .flatMapSequential(dataBuffer -> Flux.fromIterable(dataBuffer::readableByteBuffers))
                .reduce((b1, b2) -> {
                    b1.put(b2);
                    return b1;
                })
                .flatMap(buffer -> {
                    //아이의 발음내용을 텍스트로
                    Mono<String> sttResult = naverCloudClient.soundToText(buffer);

                    return sttResult
                            .flatMap(sttText -> openApiClient.letterToScore(sentence, buffer)
                                    .map(openApiResponse -> {
                                        Map<String, String> returnObject = openApiResponse.getReturn_object();
                                        Map<String, String> result = new HashMap<>();
                                        result.put("pronunciation", sttText);
                                        result.put("score", returnObject.get("score"));
                                        result.put("sentence", sentence);
                                        return result;
                                    })
                            );

                });
    }


    public Mono<Void> isPass(FilePart filePart, String sentence) {
        return filePart
                .content()
                .flatMapSequential(dataBuffer -> Flux.fromIterable(dataBuffer::readableByteBuffers))
                .reduce((b1, b2) -> {
                    b1.put(b2);
                    return b1;
                })
                .flatMap(buffer -> naverCloudClient.soundToText(buffer))
                .doOnNext(n->log.info("{}",n)).then();
        //문자열 공백 다 지우기
        //한글자씩보면서 통과범위 아닌거 다문자 하나씩 끊어서
//        {
//         isPass = false;
//        worng.add("넣")
//        worng.add("어")
//
//        }
//        return Mono.empty();
    }
}
