package com.ssafy.ggomalbe.common.repository;

import com.ssafy.ggomalbe.common.entity.NoticeEntity;
import org.springframework.data.r2dbc.repository.R2dbcRepository;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

public interface NoticeRepository extends R2dbcRepository<NoticeEntity, Long> {
    Flux<NoticeEntity> findAllByKidId(Long kidId);

    Mono<NoticeEntity> findByNoticeId(Long noticeId);

}
