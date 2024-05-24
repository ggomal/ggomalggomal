package com.ssafy.ggomalbe.common.repository;

import com.ssafy.ggomalbe.common.entity.WhaleRecordEntity;
import com.ssafy.ggomalbe.statistics.dto.WhaleStatisticResult;
import org.springframework.data.r2dbc.repository.Query;
import org.springframework.data.r2dbc.repository.R2dbcRepository;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

public interface WhaleRecordRepository extends R2dbcRepository<WhaleRecordEntity, Long> {
    @Override
    Mono<WhaleRecordEntity> save(WhaleRecordEntity entity);

    @Query("SELECT DATE(wr.created_at) as date, AVG(wr.max_time) as mean_max_time " +
            "FROM whale_record wr " +
            "WHERE wr.member_id = :kidId " +
            "GROUP BY DATE(wr.created_at) ")
    Flux<WhaleStatisticResult> findByKidIdWithMean(Long kidId);
}
