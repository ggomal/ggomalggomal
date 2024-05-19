package com.ssafy.ggomalbe.common.repository;

import com.ssafy.ggomalbe.common.entity.TeacherKidEntity;
import org.springframework.data.r2dbc.repository.R2dbcRepository;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

public interface TeacherKidRepository extends R2dbcRepository<TeacherKidEntity, Long> {
    Mono<TeacherKidEntity> findByKidIdAndTeacherId(Long kidId, Long teacherId);

    Flux<TeacherKidEntity> findByKidId(Long kidId);
}
