package com.ssafy.ggomalbe.common.repository;

import com.ssafy.ggomalbe.common.entity.MemberEntity;
import com.ssafy.ggomalbe.member.kid.dto.MemberKidResponse;
import org.springframework.data.r2dbc.repository.Modifying;
import org.springframework.data.r2dbc.repository.Query;
import org.springframework.data.r2dbc.repository.R2dbcRepository;
import org.springframework.stereotype.Repository;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

@Repository
public interface MemberRepository extends R2dbcRepository<MemberEntity, Long> {
    Mono<MemberEntity> findByUser(String user);

    @Query(value = """
                    select m.member_id as memberId,
                           m.user as user,
                           m.password as password,
                           m.name as name,
                           m.phone as phone,
                           k.kid_img_url as kidImgUrl,
                           k.kid_birth_DT as kidBirthDT,
                           k.kid_note as kidNote,
                           k.parent_name as parentName
                      from member m
                      join kid k
                        on m.member_id = ?
                       and m.role = "KID";
                    """)
    Mono<MemberKidResponse> getMemberKid(Long memberId);
}
