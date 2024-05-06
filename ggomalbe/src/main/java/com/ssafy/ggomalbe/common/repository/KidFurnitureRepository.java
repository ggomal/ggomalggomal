package com.ssafy.ggomalbe.common.repository;

import com.ssafy.ggomalbe.common.entity.KidFurnitureEntity;
import org.springframework.data.r2dbc.repository.R2dbcRepository;
import org.springframework.stereotype.Repository;
import reactor.core.publisher.Mono;

@Repository
public interface KidFurnitureRepository extends R2dbcRepository<KidFurnitureEntity, Long> {

    @Override
    Mono<KidFurnitureEntity> save(KidFurnitureEntity entity);
}
