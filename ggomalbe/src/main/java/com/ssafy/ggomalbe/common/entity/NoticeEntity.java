package com.ssafy.ggomalbe.common.entity;

import lombok.Builder;
import lombok.Data;
import org.springframework.data.annotation.Id;
import org.springframework.data.relational.core.mapping.Column;
import org.springframework.data.relational.core.mapping.Table;

@Table("notice")
@Builder
@Data
public class NoticeEntity extends AbstractEntity {
    @Id
    @Column("notice_id")
    private final Long noticeId;

    @Column("kid_id")
    private final Long kidId;

    @Column("notice_contents")
    private final String noticeContents;

    @Column("teacher_name")
    private final String teacherName;
}
