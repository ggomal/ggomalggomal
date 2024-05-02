package com.ssafy.ggomalbe.common.repository;

import com.ssafy.ggomalbe.member.kid.dto.MemberKidResponse;
import reactor.core.publisher.Mono;

public interface MemberCustomRepository {

    Mono<MemberKidResponse> getMemberKid(Long memberId);
}
