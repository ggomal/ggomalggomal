package com.ssafy.ggomalbe.member.kid;

import com.ssafy.ggomalbe.common.entity.MemberEntity;
import com.ssafy.ggomalbe.member.kid.dto.CoinResponse;
import com.ssafy.ggomalbe.member.kid.dto.KidListResponse;
import com.ssafy.ggomalbe.member.kid.dto.KidSignUpRequest;
import com.ssafy.ggomalbe.member.kid.dto.MemberKidResponse;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;


public interface KidService {

    Mono<MemberEntity> insertKid(KidSignUpRequest request);

    Mono<MemberKidResponse> getKid(Long memberId);

    Flux<KidListResponse> getKidList(Long memberId);

    Mono<CoinResponse> getOwnCoin(Long memberId);

    Mono<Integer> setCoin(Long memberId, Long coin);
}
