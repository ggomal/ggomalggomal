package com.ssafy.ggomalbe.member.controller;

import com.ssafy.ggomalbe.member.dto.LoginRequest;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;
import reactor.core.publisher.Mono;

@RestController
public class AuthController {

    @PostMapping("login")
    public Mono<ResponseEntity<String>> login(@RequestBody LoginRequest user){
        return Mono.just(ResponseEntity.ok(""));
    }
}
