package com.ssafy.ggomalbe.member.kid;

import com.ssafy.ggomalbe.common.entity.MemberEntity;
import com.ssafy.ggomalbe.member.kid.dto.*;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;


public interface KidService {

    Mono<KidSignUpResponse> insertKid(KidSignUpRequest request);

    Mono<MemberKidResponse> getKid(Long memberId);

    Flux<KidListResponse> getKidList(Long memberId);

    Mono<CoinResponse> getOwnCoin(Long memberId);

    Mono<Integer> setCoin(Long memberId, Long coin);

    Mono<Integer> addCoin(Long memberId, Long coin);

    Mono<Integer> minusCoin(Long memberId, Long coin);

}
