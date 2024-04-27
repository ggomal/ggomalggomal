package com.ssafy.ggomalbe.common.repository;

import com.ssafy.ggomalbe.common.entity.MemberEntity;
import org.springframework.data.r2dbc.repository.R2dbcRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface MemberRepository extends R2dbcRepository<MemberEntity, Long> {

}
