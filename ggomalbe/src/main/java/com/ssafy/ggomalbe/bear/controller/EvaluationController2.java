package com.ssafy.ggomalbe.bear.controller;

import com.google.gson.Gson;
import com.ssafy.ggomalbe.bear.service.OpenApiClient;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.core.io.buffer.DataBufferUtils;
import org.springframework.http.codec.multipart.FilePart;
import org.springframework.web.bind.annotation.*;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

import java.io.ByteArrayOutputStream;
import java.io.DataOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.nio.ByteBuffer;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Base64;
import java.util.HashMap;
import java.util.Map;

@RestController
@RequiredArgsConstructor
@Slf4j
public class EvaluationController2 {
    private final OpenApiClient openApiClient;
    @PostMapping("/bear/evaluation2")
    public Mono<String> openApi(@RequestPart("letter") String letter, @RequestPart("files")  FilePart filePart) {
        log.info("{} {}",letter, filePart);
        filePart
                .content()
                .flatMapSequential(dataBuffer -> Flux.fromIterable(dataBuffer::readableByteBuffers))
                .reduce((b1, b2) -> {
                    b1.put(b2);
                    return b1;
                })
                .flatMap(buffer -> openApiClient.test(letter, buffer))
                .doOnNext((result) -> log.info(result))
                .subscribe();

        return Mono.just("발음평가진행중");
    }
}