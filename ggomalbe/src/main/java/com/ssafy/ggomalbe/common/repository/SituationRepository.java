package com.ssafy.ggomalbe.common.repository;

import com.ssafy.ggomalbe.chick.dto.ChickListResponse;
import com.ssafy.ggomalbe.common.entity.SituationEntity;
import com.ssafy.ggomalbe.furniture.dto.FurnitureListResponse;
import org.springframework.data.r2dbc.repository.Query;
import org.springframework.data.r2dbc.repository.R2dbcRepository;
import reactor.core.publisher.Flux;

public interface SituationRepository extends R2dbcRepository<SituationEntity, Long> {

    @Query(value = """
        select s.situation_id as id, s.situation_title as title, if(sk.member_id , 'true', 'false') as acquired
          from situation s
          left join situation_kid sk
        	on sk.member_id = :memberId
           and s.situation_id = sk.situation_id;
        """)
    Flux<ChickListResponse> getOwnSituationList(Long memberId);

}
