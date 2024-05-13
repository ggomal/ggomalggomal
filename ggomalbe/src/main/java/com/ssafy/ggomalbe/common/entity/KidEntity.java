package com.ssafy.ggomalbe.common.entity;

import lombok.Builder;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import lombok.ToString;
import org.springframework.data.relational.core.mapping.Column;
import org.springframework.data.relational.core.mapping.Table;

import java.time.LocalDate;

@Table("kid")
@Getter
@Builder
@ToString
public class KidEntity extends AbstractEntity {

    @Column("member_id")
    private final Long memberId;

    @Column("kid_img_url")
    private final String kidImgUrl;

    @Column("kid_birth_DT")
    private final LocalDate kidBirthDT;

    @Column("kid_note")
    private final String kidNote;

    @Column("parent_name")
    private final String parentName;

    @Column("coin")
    private final Long coin;

    @Column("gender")
    private final Gender gender;

    @Getter
    @RequiredArgsConstructor
    public enum Gender {
        MALE("남자"), FEMALE("여자"), ETC("기타");

        private final String description;
    }
}
