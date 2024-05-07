package com.ssafy.ggomalbe.bear.service;

import com.ssafy.ggomalbe.bear.dto.BearRecordResponse;
import com.ssafy.ggomalbe.common.entity.BearRecordEntity;
import com.ssafy.ggomalbe.common.repository.BearRecordRepository;
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
    private final NaverCloudClient naverCloudClient;
    private final OpenApiClient openApiClient;


    //특정 멤버 기록 조회 후 날짜별로 정렬(게임 아이디로 정렬)
    public Flux<BearRecordEntity> getBearRecords(Long id) {
        return bearRecordRepository.findByMemberId(id);
    }


    @Override
    public Mono<BearRecordResponse> addBearRecord(FilePart filePart, Long memberId, Long gameNum, Long wordId, String letter, Short pronCount) {
        return evaluation(filePart, letter)
                .flatMap((evaluateResult) -> {
                    float score = Float.parseFloat(evaluateResult.get("score"));
                    String pronunciation = evaluateResult.get("pronunciation");

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



    /**
     * 평가데이터 저장
     * @param letter : 말해야 하는 정답 단어
     * @param filePart : 아이가 단어를 읽고 녹음한 데이터
     * @return
     * score: letter와 아이의 음성을 비교하여 도출한 점수
     * stt: 아이의 음성을 텍스트로 변환한 문자열
     * letter : 아이가 말해야하는 정답 단어
     */
    public Mono<Map<String, String>> evaluation(FilePart filePart, String letter) {
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
                            .flatMap(sttText -> openApiClient.letterToScore(letter, buffer)
                                    .map(openApiResponse -> {
                                        log.info("openApiResponse {}", openApiResponse);
                                        Map<String, String> returnObject = openApiResponse.getReturn_object();
                                        Map<String, String> result = new HashMap<>();
                                        result.put("pronunciation", sttText);
                                        result.put("score", returnObject.get("score"));
                                        result.put("letter", letter);
                                        return result;
                                    })
                            );

                });
    }
}
