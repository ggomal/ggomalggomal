package com.ssafy.ggomalbe.bear.controller;

import com.ssafy.ggomalbe.bear.dto.BearRecordResponse;
import com.ssafy.ggomalbe.common.config.security.CustomAuthentication;
import com.ssafy.ggomalbe.common.entity.MemberEntity;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.MediaType;
import org.springframework.http.codec.multipart.FilePart;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.ReactiveSecurityContextHolder;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestPart;
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

    @GetMapping("/role")
    public Mono<Void> roleTest(){
        return ReactiveSecurityContextHolder.getContext()
                .map(securityContext -> (CustomAuthentication) securityContext.getAuthentication())
                .doOnNext( authentication -> {
                    log.info("role {}", authentication.getRole());
                    log.info("role {}", MemberEntity.Role.TEACHER);
                    log.info("compare {}", authentication.getRole() == MemberEntity.Role.TEACHER);
                    log.info("name {}", authentication.getName());
                    log.info("id {}", authentication.getDetails());

                }).then();
    }
}
