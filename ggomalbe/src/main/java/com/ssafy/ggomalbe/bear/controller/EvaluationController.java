package com.ssafy.ggomalbe.bear.controller;

import com.ssafy.ggomalbe.common.service.NaverCloudClient;
import com.ssafy.ggomalbe.common.service.OpenApiClient;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.http.codec.multipart.FilePart;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

@RestController
@RequiredArgsConstructor
@Slf4j
public class EvaluationController {
    private final NaverCloudClient naverCloudClient;
    private final OpenApiClient openApiClient;

    @PostMapping(value = "/bear/evaluationTest", produces = MediaType.TEXT_EVENT_STREAM_VALUE)
    public Mono<Void> stt(@RequestPart("files") FilePart filePart) {
        filePart
                .content()
                .flatMapSequential(dataBuffer -> Flux.fromIterable(dataBuffer::readableByteBuffers))
                .reduce((b1, b2) -> {
                    b1.put(b2);
                    return b1;
                })
                .flatMap(buffer -> naverCloudClient.soundToText(buffer))
                .subscribe();
        return Mono.empty();
    }
//
//    public Flux<Map<String, String>> openApi(@RequestPart("letter") String letter, @RequestPart("files") FilePart filePart) {
//        return Flux.concat(
//                Mono.just(new HashMap<>()),
//                filePart.content()
//                        .flatMapSequential(dataBuffer -> Flux.fromIterable(dataBuffer::readableByteBuffers))
//                        .reduce((b1, b2) -> {
//                            b1.put(b2);
//                            return b1;
//                        })
//                        .flatMap(buffer -> openApiClient.letterToScore(letter, buffer))
//                        .map(openApiResponse -> {
//                            log.info("openApiResponse {}", openApiResponse);
//                            Map<String, String> result = openApiResponse.getReturn_object();
//                            return result;
//                        })
//        );
//    }

}