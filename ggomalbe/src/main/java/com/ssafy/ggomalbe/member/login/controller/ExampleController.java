package com.ssafy.ggomalbe.member.login.controller;

import com.ssafy.ggomalbe.bear.handlers.RoomSocketHandler;
import com.ssafy.ggomalbe.bear.entity.Room;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RestController;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;
import reactor.core.publisher.Sinks;

import java.time.Duration;

/**
 * web flux 나의 이해..!
 * 반환타입이 Mono나 Flux인건 값이 return 될때까지 기다리는게 아니라 비동기적으로 다른일도 처리한다.
 * 그중 produces = MediaType.TEXT_EVENT_STREAM_VALUE가 옵션으로 붙은거는 sse를통해 클라이언트 에게 실시간으로 데이터를 보낼수 있다
 * Flux의 값이 대량으로 많아서 스트림으로 내보내는 것이다.(연속적 흐름데이터 -> 스트리밍이나 대량의 파일)
 * 하지만! 우리는 스트림보다 데이터베이스작업을 비동기로 처리하는 관점에서 보면 충분이 webflux를 사용할 가치가 있다!
 */
@Slf4j
@RestController
@AllArgsConstructor
public class ExampleController {
    private final Sinks.Many<String> sink = Sinks.many().multicast().directBestEffort();


    //빙고에서 아이가 생성한 룸관리, 선생님을 참가시키기위한 해시맵
    private final RoomSocketHandler groupSocketHandler;

    @GetMapping(value = "/example", produces = MediaType.TEXT_EVENT_STREAM_VALUE)
    public Flux<String> getExampleData() {
        // 예시로 간단한 스트림을 생성하여 반환
        log.info("flux test /example - 1초마다 반환합니다.");
        return Flux.just("Data 1", "Data 2", "Data 3")
                   .delayElements(Duration.ofSeconds(1)); // 1초 간격으로 데이터를 발생시킴
    }

    @GetMapping(value = "/sink", produces = MediaType.TEXT_EVENT_STREAM_VALUE)
    public Flux<String> getSink() {
        // 예시로 간단한 스트림을 생성하여 반환
        return sink.asFlux();
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
