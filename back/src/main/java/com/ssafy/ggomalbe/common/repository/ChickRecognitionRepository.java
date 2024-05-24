package com.ssafy.ggomalbe.common.repository;

import com.ssafy.ggomalbe.common.entity.ChickRecognitionEntity;
import org.springframework.data.r2dbc.repository.R2dbcRepository;
import reactor.core.publisher.Mono;

public interface ChickRecognitionRepository extends R2dbcRepository<ChickRecognitionEntity, Long> {
    Mono<Boolean> existsByOriginTextAndRecognitionScope(String originText, String recognitionScope);
}
