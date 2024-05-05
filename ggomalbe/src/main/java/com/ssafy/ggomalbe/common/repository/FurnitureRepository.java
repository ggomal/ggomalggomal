package com.ssafy.ggomalbe.common.repository;

import com.ssafy.ggomalbe.common.entity.FurnitureEntity;
import com.ssafy.ggomalbe.common.entity.KidEntity;
import com.ssafy.ggomalbe.furniture.dto.FurnitureListResponse;
import org.springframework.data.r2dbc.repository.Query;
import org.springframework.data.r2dbc.repository.R2dbcRepository;
import org.springframework.stereotype.Repository;
import reactor.core.publisher.Flux;

@Repository
public interface FurnitureRepository extends R2dbcRepository<FurnitureEntity, Long> {

    @Query(value = """
        select f.furniture_id as id, f.furniture_name as name, if(kf.member_id , 'true', 'false') as acquired
          from furniture f
          left join kid_furniture kf
            on kf.member_id = :memberId
           and f.furniture_id = kf.furniture_id;
        """)
    Flux<FurnitureListResponse> getOwnFurnitureList(Long memberId);
}
