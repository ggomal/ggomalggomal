package com.ssafy.ggomalbe.member.kid;

import com.ssafy.ggomalbe.common.config.security.CustomAuthentication;
import com.ssafy.ggomalbe.member.kid.dto.*;
import io.swagger.v3.oas.annotations.Operation;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.core.context.ReactiveSecurityContextHolder;
import org.springframework.web.bind.annotation.*;
import reactor.core.publisher.Mono;

import java.util.List;

@Slf4j
@RestController
@RequestMapping("/kid")
@RequiredArgsConstructor
public class KidController {

    private final KidService kidService;

    @PostMapping
    public Mono<KidSignUpResponse> kidSignUp(@RequestBody KidSignUpRequest request) {
        return ReactiveSecurityContextHolder.getContext()
                .map(securityContext -> (CustomAuthentication) securityContext.getAuthentication())
                .map(authentication ->{
                    request.setCenterId(authentication.getCenterId());
                    return authentication.getDetails();})
                .doOnNext(request::setTeacherId)
                .doOnNext(d -> request.setUser())
                .flatMap(l -> kidService.insertKid(request));
    }

    @Operation(description = "담당 아이 목록 조회")
    @GetMapping
    public Mono<List<KidListResponse>> getKidList(){
        return ReactiveSecurityContextHolder.getContext()
                .map(securityContext ->
                        (Long) securityContext.getAuthentication().getDetails())
                .flatMap(memberId ->
                        kidService.getKidList(memberId).collectList());
    }

    @Operation(description = "아이 상세정보 조회")
    @GetMapping("/{memberId}")
    public Mono<MemberKidResponse> getKid(@PathVariable Long memberId) {
        return kidService.getKid(memberId);
    }

    @Operation(description = "아이 보유 재화 조회")
    @GetMapping("/coin")
    public Mono<CoinResponse> getCoin(){
        return ReactiveSecurityContextHolder.getContext()
                .map(securityContext ->
                        (Long) securityContext.getAuthentication().getDetails())
                .flatMap(memberId ->
                   kidService.getOwnCoin(memberId));
    }


}
