package com.ssafy.ggomalbe.member.kid;

import com.mysql.cj.log.Log;
import com.ssafy.ggomalbe.common.entity.MemberEntity;
import com.ssafy.ggomalbe.member.dto.KidSignUpRequest;
import com.ssafy.ggomalbe.member.kid.dto.MemberKidResponse;
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

    @PostMapping
    public Mono<MemberEntity> kidSignUp(@RequestBody KidSignUpRequest request) {
        return ReactiveSecurityContextHolder.getContext()
                .map(securityContext ->
                    (Long) securityContext.getAuthentication().getDetails())
                .doOnNext(request::setTeacherId)
                .flatMap(l -> kidService.insertKid(request));
    }

    @GetMapping
    public Flux<String> getKids(){
        return Flux.fromArray(new String[] {"1","2","3","4","5"});
    }

    @GetMapping("/{memberId}")
    public Mono<MemberKidResponse> getKid(@PathVariable Long memberId) {
//        return ReactiveSecurityContextHolder.getContext()
//                .map(securityContext ->
//                        (Long) securityContext.getAuthentication().getDetails())
//                .flatMap(kidId ->
//                        kidService.getKid(Long.parseLong(String.valueOf(4))));
        return kidService.getKid(memberId);

    }
}
