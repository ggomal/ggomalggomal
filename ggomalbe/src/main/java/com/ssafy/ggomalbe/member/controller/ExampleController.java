package com.ssafy.ggomalbe.member.controller;

import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RestController;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;
import reactor.core.publisher.Sinks;

import java.io.IOException;
import java.time.Duration;

@Slf4j
@RestController
@AllArgsConstructor
public class ExampleController {

    private final Sinks.Many<String> sink;

    @GetMapping(value = "/example", produces = MediaType.TEXT_EVENT_STREAM_VALUE)
    public Flux<String> getExampleData() {
        // 예시로 간단한 스트림을 생성하여 반환
        log.info("flux test /example - 1초마다 반환합니다.");
        return Flux.just("Data 1", "Data 2", "Data 3")
                   .delayElements(Duration.ofSeconds(1)); // 1초 간격으로 데이터를 발생시킴
    }

    @GetMapping("/test")
    public void test(){
        Mono.just("Hello Reactor")
                .subscribe(m -> System.out.println(m));
    }

    @GetMapping("/test2")
    public void test2(){
        //퍼블리셔가 데이터 생성, 생성된 데이터 오퍼레이터로 가공, 서브스트라이터 전송
        Flux<String> seq = Flux.just("Hello", "Reactor");
        seq
                .map(data -> data.toLowerCase())
                .subscribe(data -> System.out.println(data));
    }

    @PostMapping("/demo")
    public void demo(){
        sink.emitNext("hello", Sinks.EmitFailureHandler.FAIL_FAST);
    }
}
