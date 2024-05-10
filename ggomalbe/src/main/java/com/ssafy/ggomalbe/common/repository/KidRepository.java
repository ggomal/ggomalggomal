package com.ssafy.ggomalbe.common.repository;

import com.ssafy.ggomalbe.common.entity.KidEntity;
import org.springframework.data.r2dbc.repository.Modifying;
import org.springframework.data.r2dbc.repository.Query;
import org.springframework.data.r2dbc.repository.R2dbcRepository;
import reactor.core.publisher.Mono;

public interface KidRepository extends R2dbcRepository<KidEntity, Long> {

    @Modifying
    @Query("UPDATE kid SET coin = :coin where member_id = :memberId;")
    Mono<Integer> setCoin(Long memberId, Long coin);

    @Modifying
    @Query("UPDATE kid SET coin = coin + :coin where member_id = :memberId;")
    Mono<Integer> addCoin(Long memberId, Long coin);


    Mono<KidEntity> findByMemberId(Long memberId);
}
