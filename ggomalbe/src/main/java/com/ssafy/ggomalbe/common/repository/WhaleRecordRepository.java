package com.ssafy.ggomalbe.common.repository;

import com.ssafy.ggomalbe.common.entity.FrogRecordEntity;
import com.ssafy.ggomalbe.common.entity.WhaleRecordEntity;
import org.springframework.data.r2dbc.repository.R2dbcRepository;
import reactor.core.publisher.Mono;

public interface WhaleRecordRepository extends R2dbcRepository<WhaleRecordEntity, Long> {


    @Override
    Mono<WhaleRecordEntity> save(WhaleRecordEntity entity);
}
