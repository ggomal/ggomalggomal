package com.ssafy.ggomalbe.common.entity;


import lombok.Builder;
import org.springframework.data.annotation.Id;
import org.springframework.data.relational.core.mapping.Column;
import org.springframework.data.relational.core.mapping.Table;

@Table("homework")
@Builder
public class HomeworkEntity extends AbstractEntity {
    @Id
    @Column("homework_id")
    private final Long homeworkId;

    @Column("notice_id")
    private final Long noticeId;

    @Column("homework_contents")
    private final String homeworkContents;

    @Column("is_done")
    private final Boolean isDone;
}
