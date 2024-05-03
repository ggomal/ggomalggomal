package com.ssafy.ggomalbe.common.repository;

import com.ssafy.ggomalbe.common.entity.KidEntity;
import org.springframework.data.r2dbc.repository.R2dbcRepository;
import reactor.core.publisher.Mono;

public interface KidRepository extends R2dbcRepository<KidEntity, Long> {

}
