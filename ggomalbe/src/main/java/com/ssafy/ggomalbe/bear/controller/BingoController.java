package com.ssafy.ggomalbe.bear.controller;

import com.ssafy.ggomalbe.bear.entity.BingoBoard;
import com.ssafy.ggomalbe.bear.service.BingoSocketService;
import com.ssafy.ggomalbe.common.config.security.CustomAuthentication;
import com.ssafy.ggomalbe.common.entity.MemberEntity;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.core.context.ReactiveSecurityContextHolder;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import reactor.core.publisher.Mono;

@RestController
@Slf4j
@RequiredArgsConstructor
@RequestMapping("/bear")
public class BingoController {
    private final BingoSocketService bingoSocketService;

//    @GetMapping("/test")
//    public String testString() {
//        return "test success";
//    }
//
////    @GetMapping("/create")
////    public BingoBoard test() {
////        return bingoSocketService.createBingoBoard();
////    }
//
//    @GetMapping("/find")
//    public void find() {
////        bingoSocketService.findBingoCard();
//    }
//
//    @GetMapping("/enum")
//    public void enumTest() {
//        System.out.println(MemberEntity.Role.TEACHER);
//    }
//
//    @GetMapping("/token")
//    public Mono<MemberEntity.Role> authTest() {
//        return ReactiveSecurityContextHolder.getContext()
//                .map(securityContext ->
//                        (CustomAuthentication) securityContext.getAuthentication())
//                .map(n->n.getRole())
//                .doOnNext(n->log.info("{}",n));
//    }
}
