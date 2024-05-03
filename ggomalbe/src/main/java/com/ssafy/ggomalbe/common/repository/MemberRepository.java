package com.ssafy.ggomalbe.common.repository;

import com.ssafy.ggomalbe.common.entity.MemberEntity;
import com.ssafy.ggomalbe.member.kid.dto.KidListResponse;
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
                    select m.member_id as member_id,
                           m.user as id,
                           m.password as password,
                           m.name as name,
                           m.phone as parent_phone,
                           k.kid_img_url as kid_img_url,
                           k.kid_birth_DT as kid_birth_DT,
                           k.kid_note as kid_note,
                           k.parent_name as parent_name
                      from member m
                      join kid k
                        on m.member_id = memberId
                       and m.member_id = k.member_id
                       and m.role = "KID";
                    """)
    Mono<MemberKidResponse> getMemberKid(Long memberId);



    @Query(value = """
                select m.member_id as member_id, m.user as id, m.password as password, m.name as name, k.kid_birth_DT
                  from member m, teacher_kid tk, kid k
                 where tk.teacher_id = :memberId
                   and tk.kid_id = m.member_id
                   and k.member_id = m.member_id;
                """)
    Flux<KidListResponse> getKidList(Long memberId);




}
