package com.ssafy.ggomalbe.common.repository;

import com.ssafy.ggomalbe.common.entity.BearRecordEntity;
import com.ssafy.ggomalbe.common.entity.WordEntity;
import com.ssafy.ggomalbe.statistics.dto.WordAccuracyResult;
import com.ssafy.ggomalbe.statistics.dto.WordMostResult;
import org.springframework.data.r2dbc.repository.Query;
import org.springframework.data.r2dbc.repository.R2dbcRepository;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

import java.util.List;
import java.util.Set;

public interface BearRecordRepository extends R2dbcRepository<BearRecordEntity,Long> {
    public Flux<BearRecordEntity> findBearRecordEntitiesByMemberId(Long memberId);
    Flux<BearRecordEntity> findByMemberId(Long memberId);

    @Query("SELECT DATE(br.created_at) as date, AVG(br.score) as accuracy_mean " +
            "FROM bear_record br " +
            "LEFT OUTER JOIN word w ON br.word_id = w.word_id " +
            "WHERE br.member_id = :kidId " +
            "AND w.initial in (:initial) " +
            "GROUP BY DATE(br.created_at)")
    Flux<WordAccuracyResult> findAccuracyDateByKidIdAndInitial(Long kidId, Set<String> initial);

    @Query("SELECT w.letter as word, COUNT(w.word_id) as count " +
            "FROM bear_record br " +
            "LEFT OUTER JOIN word w ON br.word_id = w.word_id " +
            "WHERE br.member_id = :kid_id " +
            "GROUP BY w.word_id " +
            "ORDER BY COUNT(w.word_id) DESC " +
            "LIMIT 5 ")
    Flux<WordMostResult> findMostUsedByKidId(Long kidId);
}


