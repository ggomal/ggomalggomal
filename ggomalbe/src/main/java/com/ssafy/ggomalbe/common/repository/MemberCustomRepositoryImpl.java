package com.ssafy.ggomalbe.common.repository;

import com.ssafy.ggomalbe.member.kid.dto.KidResponse;
import com.ssafy.ggomalbe.member.kid.dto.MemberKidResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.r2dbc.core.DatabaseClient;
import org.springframework.stereotype.Repository;
import reactor.core.publisher.Mono;

import java.time.LocalDate;
import java.time.Period;

@Slf4j
@Repository
@RequiredArgsConstructor
public class MemberCustomRepositoryImpl implements  MemberCustomRepository{

    private final DatabaseClient databaseClient;

    @Override
    public Mono<MemberKidResponse> getMemberKid(Long memberId) {
        String sql = """
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
                    on m.member_id = ?;
                """;

        return databaseClient.sql(sql)
                .bind(0, memberId)
                .map((row, rowMetadata) -> {
                    return MemberKidResponse.builder()
                            .memberId(row.get("memberId", Long.class))
                            .id(row.get("user", String.class))
                            .password(row.get("password", String.class))
                            .name(row.get("name", String.class))
                            .parentPhone(row.get("phone", String.class))
                            .kidResponse(KidResponse.builder()
                                    .kidImgUrl(row.get("kidImgUrl", String.class))
                                    .age(Period.between(row.get("kidBirthDT", LocalDate.class), LocalDate.now()).getYears())
                                    .kidNote(row.get("kidNote", String.class))
                                    .parentName(row.get("parentName", String.class))
                                    .build())
                            .build();
                }).one();
    }
}
