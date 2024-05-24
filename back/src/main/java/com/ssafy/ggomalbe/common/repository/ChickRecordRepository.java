package com.ssafy.ggomalbe.common.repository;

import com.ssafy.ggomalbe.common.entity.ChickRecordEntity;
import com.ssafy.ggomalbe.statistics.dto.ChickAccuracyResult;
import org.springframework.data.r2dbc.repository.Query;
import org.springframework.data.r2dbc.repository.R2dbcRepository;
import org.springframework.stereotype.Repository;
import reactor.core.publisher.Flux;

@Repository
public interface ChickRecordRepository extends R2dbcRepository<ChickRecordEntity, Long> {

    @Query("SELECT DATE(cr.created_at) as date, AVG(cr.score) as accuracy_mean " +
            "FROM chick_record cr " +
            "WHERE cr.member_id = :kidId " +
            "GROUP BY DATE(cr.created_at)")
    Flux<ChickAccuracyResult> findAccuracyDateByKidId(Long kidId);
}
