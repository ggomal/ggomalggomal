package com.ssafy.ggomalbe.common.repository;

import com.ssafy.ggomalbe.common.entity.BearRecordEntity;
import com.ssafy.ggomalbe.common.entity.WordEntity;
import org.springframework.data.r2dbc.repository.Query;
import org.springframework.data.r2dbc.repository.R2dbcRepository;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

import java.util.List;

public interface BearRecordRepository extends R2dbcRepository<BearRecordEntity,Long> {
    public Flux<BearRecordEntity> findBearRecordEntitiesByMemberId(Long memberId);
    Flux<BearRecordEntity> findByMemberId(Long memberId);
}


