package com.ssafy.ggomalbe.common.service;

import com.ssafy.ggomalbe.common.dto.EvaluationDto;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.codec.multipart.FilePart;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

import java.nio.ByteBuffer;
import java.util.HashMap;
import java.util.Map;

@Service
@Transactional
@Slf4j
@RequiredArgsConstructor
public class EvaluationService{
    private final NaverCloudClient naverCloudClient;
    private final OpenApiClient openApiClient;


    /**
     * 평가데이터 저장
     * @param originText : 말해야 하는 정답 단어
     * @param filePart : 아이가 단어를 읽고 녹음한 데이터
     * @return
     * score: originText와 아이의 음성을 비교하여 도출한 점수
     * stt: 아이의 음성을 텍스트로 변환한 문자열
     * letter : 아이가 말해야하는 정답 단어
     */
    public Mono<EvaluationDto> evaluation(FilePart filePart, String originText) {
        return toBuffer(filePart)
                .flatMap(buffer -> {
                    //아이의 발음내용을 텍스트로
                    Mono<String> sttResult = naverCloudClient.soundToText(buffer);

                    return sttResult
                            .flatMap(pronunciation -> openApiClient.letterToScore(pronunciation, buffer)
                                    .map(openApiResponse -> {
                                        log.info("openApiResponse {}", openApiResponse);
                                        Map<String, String> returnObject = openApiResponse.getReturn_object();
                                        String scoreStr = returnObject.get("score");
                                        float score = 0;
                                        try{
                                            score = Float.parseFloat(returnObject.get("score"));
                                        }catch (NumberFormatException e){
                                            log.error("error NumberFormatException {} ", scoreStr);
                                        }
                                        return EvaluationDto.builder()
                                                .pronunciation(pronunciation)
                                                .score(score)
                                                .originText(originText)
                                                .build();
                                    })
                            );

                });
    }
    /** stt */
    public Mono<String> toText(FilePart filePart){
        //아이의 발음내용을 텍스트로
        return toBuffer(filePart)
                .flatMap(naverCloudClient::soundToText);
    }

    /** filePart to byteBuffer */
    public Mono<ByteBuffer> toBuffer(FilePart filePart){
        return filePart.content()
                .flatMapSequential(dataBuffer -> Flux.fromIterable(dataBuffer::readableByteBuffers))
                .reduce((b1, b2) -> {
                    b1.put(b2);
                    return b1;
                });
    }
}
