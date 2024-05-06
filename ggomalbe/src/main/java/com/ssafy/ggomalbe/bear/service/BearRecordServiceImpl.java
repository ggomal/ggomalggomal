package com.ssafy.ggomalbe.bear.service;

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
public class BearRecordServiceImpl implements BearRecordService{
    private final BearRecordRepository bearRecordRepository;
    private final NaverCloudClient naverCloudClient;
    private final OpenApiClient openApiClient;

//    //저장
//    public Mono<BearRecordEntity> addBearRecord(BearRecordRequest bearRecordRequest) {
//        return bearRecordRepository.save(bearRecordRequest);
//    }
//
//
//    //특정 멤버 기록 조회 후 날짜별로 정렬(게임 아이디로 정렬)
//    public Flux<BearRecordResponse> getBearRecordsKidId(Long id) {
//        return bearRecordRepository.findBearRecordEntitiesByMemberId(id);
//    }
//
//    public Mono<>


    public Mono<Map<String, String>> evaluate(FilePart filePart, String letter) {
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
                                        result.put("stt", sttText);
                                        result.put("score", returnObject.get("score"));
                                        result.put("letter", letter);
                                        return result;
                                    })
                            );

                });
    }
}
