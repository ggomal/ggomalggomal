package com.ssafy.ggomalbe.common.repository;

import com.ssafy.ggomalbe.common.entity.ScheduleEntity;
import org.springframework.data.r2dbc.repository.R2dbcRepository;

public interface ScheduleRepository extends R2dbcRepository<ScheduleEntity, Long> {
}
