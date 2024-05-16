package com.ssafy.ggomalbe.common.repository;

import com.ssafy.ggomalbe.common.entity.NoticeEntity;
import org.springframework.data.r2dbc.repository.Query;
import org.springframework.data.r2dbc.repository.R2dbcRepository;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

import java.time.LocalDate;

public interface NoticeRepository extends R2dbcRepository<NoticeEntity, Long> {
    @Query("SELECT notice.notice_id, notice.kid_id, notice.notice_contents, notice.teacher_name, notice.created_at, notice.modified_at, notice.deleted_at " +
            "FROM notice " +
            "WHERE notice.kid_id = :kidId AND (MONTH(notice.created_at) = :month) " +
            "ORDER BY notice.notice_id DESC")
    Flux<NoticeEntity> findAllByKidIdAndCreatedAtMonth(Long kidId, Integer month);

    @Query("SELECT n.notice_id, n.kid_id, n.notice_contents, n.teacher_name, n.created_at, n.modified_at, n.deleted_at " +
            "FROM notice n " +
            "WHERE DATE(n.created_at)= :createdDate " +
            "AND n.kid_id = :kidId " +
            "LIMIT 1")
    Mono<NoticeEntity> findByCreatedAt(Long kidId, LocalDate createdDate);

}
