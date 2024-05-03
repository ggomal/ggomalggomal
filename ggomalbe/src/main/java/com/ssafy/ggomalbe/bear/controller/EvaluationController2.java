package com.ssafy.ggomalbe.bear.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.gson.Gson;
import com.ssafy.ggomalbe.bear.dto.OpenApiResponse;
import com.ssafy.ggomalbe.bear.service.OpenApiClient;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.MediaType;
import org.springframework.http.codec.multipart.FilePart;
import org.springframework.web.bind.annotation.*;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequiredArgsConstructor
@Slf4j
public class EvaluationController2 {
    private final OpenApiClient openApiClient;
    private final ObjectMapper objectMapper;
    private final Gson gson;

    @PostMapping(value = "/bear/evaluation2", produces = MediaType.TEXT_EVENT_STREAM_VALUE)
    public Flux<Map<String, String>> openApi(@RequestPart("letter") String letter, @RequestPart("files") FilePart filePart) {
        return Flux.concat(
                Mono.just(new HashMap<>()),
                filePart.content()
                        .flatMapSequential(dataBuffer -> Flux.fromIterable(dataBuffer::readableByteBuffers))
                        .reduce((b1, b2) -> {
                            b1.put(b2);
                            return b1;
                        })
                        .flatMap(buffer -> openApiClient.letterToScore(letter, buffer))
                        .map(jsonString -> {
                            OpenApiResponse openApiResponse = gson.fromJson(jsonString, OpenApiResponse.class);
                            Map<String, String> result = openApiResponse.getReturn_object();

                            log.info("{}", result);
                            return result;
                        })
        );
    }
}

//3. 평가데이터 저장하기
//1. 웹소켓테스트 - 아이, 선생님선택했을때 모달이 잘 뜨는지
//2. api명세 쓰기