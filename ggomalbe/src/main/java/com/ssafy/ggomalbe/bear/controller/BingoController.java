package com.ssafy.ggomalbe.bear.controller;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;
import reactor.core.publisher.Sinks;

@RestController
@Slf4j
@RequiredArgsConstructor
@RequestMapping("/bear")
public class BingoController {
    Sinks.Many<String> sink = Sinks.many().multicast().directBestEffort();

    @GetMapping(value = "/sink", produces = MediaType.TEXT_EVENT_STREAM_VALUE)
    public Flux<String> sinkTest(){
        return sink.asFlux();
    }

    @GetMapping("/emit")
    public Mono<Void> emitTest(){
        sink.tryEmitNext("sink test");
        return Mono.empty();
    }
}
