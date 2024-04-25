package com.ssafy.ggomalbe.member.kid;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

@RestController
@RequestMapping("/api/v1/kid")
public class KidController {

    @PostMapping
    public Mono<String> addKid(){
        return Mono.just("plz");
    }

    @GetMapping
    public Flux<String> getKid(){
        return Flux.fromArray(new String[] {"1","2","3","4","5"});
    }
}
