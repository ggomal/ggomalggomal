package com.ssafy.ggomalbe.common.repository;

import com.ssafy.ggomalbe.common.entity.GameNumEntity;
import org.springframework.data.r2dbc.repository.R2dbcRepository;

public interface GameNumRepository extends R2dbcRepository<GameNumEntity,Long> {

}
