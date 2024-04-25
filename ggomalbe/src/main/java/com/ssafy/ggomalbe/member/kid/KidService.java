package com.ssafy.ggomalbe.member.kid;

import com.ssafy.ggomalbe.common.entity.MemberEntity;
import reactor.core.publisher.Mono;

public interface KidService {
    Mono<MemberEntity> insertKid();
}
