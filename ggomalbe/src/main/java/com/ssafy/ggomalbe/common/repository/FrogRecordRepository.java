package com.ssafy.ggomalbe.common.repository;

import com.ssafy.ggomalbe.common.entity.FrogRecordEntity;
import org.springframework.data.r2dbc.repository.R2dbcRepository;
import reactor.core.publisher.Mono;

public interface FrogRecordRepository extends R2dbcRepository<FrogRecordEntity, Long> {

    @Override
    Mono<FrogRecordEntity> save(FrogRecordEntity entity);
}
