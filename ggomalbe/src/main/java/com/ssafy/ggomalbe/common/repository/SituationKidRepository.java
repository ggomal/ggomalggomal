package com.ssafy.ggomalbe.common.repository;

import com.ssafy.ggomalbe.common.entity.SituationKidEntity;
import org.springframework.data.r2dbc.repository.R2dbcRepository;
import reactor.core.publisher.Mono;

public interface SituationKidRepository extends R2dbcRepository<SituationKidEntity, Long> {


    Mono<Long> countByMemberId(Long memberId);
}
