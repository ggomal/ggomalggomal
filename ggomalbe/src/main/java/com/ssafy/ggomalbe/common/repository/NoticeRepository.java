package com.ssafy.ggomalbe.common.repository;

import com.ssafy.ggomalbe.common.entity.NoticeEntity;
import com.ssafy.ggomalbe.notice.dto.NoticeResponse;
import org.springframework.data.r2dbc.repository.Modifying;
import org.springframework.data.r2dbc.repository.Query;
import org.springframework.data.r2dbc.repository.R2dbcRepository;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

public interface NoticeRepository extends R2dbcRepository<NoticeEntity, Long> {
    Flux<NoticeEntity> findByKidId(Long kidId);

    /**
     * response로 return
     * @return NoticeResponse
     */
    @Modifying
    @Query(value = "SELECT n.notice_id as notice_id, n.kid_id as kid_id, n.notice_contents as notice_contents, n.teacher_name " +
            "FROM notice n " +
            "LEFT OUTER JOIN homework h " +
            "ON n.notice_id = h.notice_id " +
            "WHERE n.notice_id = :noticeId ")
    Mono<NoticeResponse> findByNoticeId(Long noticeId);

}
