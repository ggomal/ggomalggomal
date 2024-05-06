package com.ssafy.ggomalbe.common.repository;

import com.ssafy.ggomalbe.common.entity.ChickRecordEntity;
import org.springframework.data.r2dbc.repository.R2dbcRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ChickRecordRepository extends R2dbcRepository<ChickRecordEntity, Long> {
}
