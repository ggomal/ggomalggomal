package com.ssafy.ggomalbe.common.repository;

import com.ssafy.ggomalbe.common.entity.TeacherKidEntity;
import org.springframework.data.r2dbc.repository.R2dbcRepository;

public interface TeacherKidRepository extends R2dbcRepository<TeacherKidEntity, Long> {
}
