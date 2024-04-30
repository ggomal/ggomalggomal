package com.ssafy.ggomalbe.common.repository;

import com.ssafy.ggomalbe.common.entity.HomeworkEntity;
import org.springframework.data.r2dbc.repository.Modifying;
import org.springframework.data.r2dbc.repository.Query;
import org.springframework.data.r2dbc.repository.R2dbcRepository;
import reactor.core.publisher.Flux;

import java.util.Set;

public interface HomeworkRepository extends R2dbcRepository<HomeworkEntity, Long> {
    Flux<HomeworkEntity> findAllByNoticeId(Long noticeId);

    Flux<Void> deleteAllByNoticeId(Long noticeId);
}
