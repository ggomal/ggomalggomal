package com.ssafy.ggomalbe.common.repository;

import com.ssafy.ggomalbe.common.entity.MemberEntity;
import org.springframework.data.r2dbc.repository.R2dbcRepository;
import org.springframework.stereotype.Repository;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

@Repository
public interface MemberRepository extends R2dbcRepository<MemberEntity, Long> {
    Mono<MemberEntity> findByUser(String user);

}
