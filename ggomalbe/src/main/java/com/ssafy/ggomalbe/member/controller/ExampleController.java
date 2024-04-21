package com.ssafy.ggomalbe.member.controller;

import lombok.extern.slf4j.Slf4j;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import reactor.core.publisher.Flux;

import java.time.Duration;

@Slf4j
@RestController
public class ExampleController {

    @GetMapping(value = "/example", produces = MediaType.TEXT_EVENT_STREAM_VALUE)
    public Flux<String> getExampleData() {
        // 예시로 간단한 스트림을 생성하여 반환
        log.info("flux test");
        return Flux.just("Data 1", "Data 2", "Data 3")
                   .delayElements(Duration.ofSeconds(1)); // 1초 간격으로 데이터를 발생시킴
    }
}