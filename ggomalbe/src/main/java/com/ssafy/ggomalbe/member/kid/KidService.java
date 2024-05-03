package com.ssafy.ggomalbe.member.kid;

import com.ssafy.ggomalbe.common.entity.MemberEntity;
import com.ssafy.ggomalbe.member.kid.dto.KidSignUpRequest;
import com.ssafy.ggomalbe.member.kid.dto.MemberKidResponse;
import reactor.core.publisher.Mono;


public interface KidService {

    Mono<MemberEntity> insertKid(KidSignUpRequest request);

    Mono<MemberKidResponse> getKid(Long memberId);

}
