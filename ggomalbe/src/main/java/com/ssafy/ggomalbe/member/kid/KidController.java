package com.ssafy.ggomalbe.member.kid;

import com.mysql.cj.log.Log;
import com.ssafy.ggomalbe.member.kid.dto.MemberKidResponse;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.core.context.ReactiveSecurityContextHolder;
import org.springframework.web.bind.annotation.*;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

@Slf4j
@RestController
@RequestMapping("/kid")
@RequiredArgsConstructor
public class KidController {

    private final KidService kidService;

    @GetMapping
    public Flux<String> getKids(){
        System.out.println("get kids 12345");
        return Flux.fromArray(new String[] {"1","2","3","4","5"});

//        return ReactiveSecurityContextHolder.getContext()
//                .map(securityContext ->
//                        (Long) securityContext.getAuthentication().getDetails())
//                .flatMap(kidId ->
//                        kidService.getKid(Long.parseLong(String.valueOf(4))));
    }

    @GetMapping("/{memberId}")
    public Mono<MemberKidResponse> getKid(@PathVariable Long memberId) {
        System.out.println("member ID : " + memberId);
        return kidService.getKid(memberId);
    }
}
