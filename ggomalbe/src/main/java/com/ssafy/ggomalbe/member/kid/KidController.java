package com.ssafy.ggomalbe.member.kid;

import com.ssafy.ggomalbe.common.config.security.CustomAuthentication;
import com.ssafy.ggomalbe.common.entity.MemberEntity;
import com.ssafy.ggomalbe.member.kid.dto.KidSignUpRequest;
import com.mysql.cj.log.Log;
import com.ssafy.ggomalbe.member.kid.dto.KidListResponse;
import com.ssafy.ggomalbe.member.kid.dto.MemberKidResponse;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.core.context.ReactiveSecurityContextHolder;
import org.springframework.web.bind.annotation.*;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

import java.util.List;

@Slf4j
@RestController
@RequestMapping("/kid")
@RequiredArgsConstructor
public class KidController {

    private final KidService kidService;

    @PostMapping
    public Mono<MemberEntity> kidSignUp(@RequestBody KidSignUpRequest request) {
        return ReactiveSecurityContextHolder.getContext()
                .map(securityContext -> (CustomAuthentication) securityContext.getAuthentication())
                .map(authentication ->{
                    request.setCenterId(authentication.getCenterId());
                    return authentication.getDetails();})
                .doOnNext(request::setTeacherId)
                .flatMap(l -> kidService.insertKid(request));
    }

    @GetMapping
    public Mono<List<KidListResponse>> getKid(){
        return ReactiveSecurityContextHolder.getContext()
                .map(securityContext ->
                        (Long) securityContext.getAuthentication().getDetails())
                .flatMap(memberId ->
                        kidService.getKidList(memberId).collectList());
    }

    @GetMapping("/{memberId}")
    public Mono<MemberKidResponse> getKid(@PathVariable Long memberId) {
        System.out.println("member ID : " + memberId);
        return kidService.getKid(memberId);

    }
}
