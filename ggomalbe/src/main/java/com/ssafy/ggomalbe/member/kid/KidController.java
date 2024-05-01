package com.ssafy.ggomalbe.member.kid;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

@Slf4j
@RestController
@RequestMapping("/kid")
@RequiredArgsConstructor
public class KidController {

    private final KidService kidService;

    @PostMapping
    public Mono<String> addKid(){
        return Mono.just("plz");
    }

    @GetMapping
    public Flux<String> getKid(){
        return Flux.fromArray(new String[] {"1","2","3","4","5"});
    }
}
