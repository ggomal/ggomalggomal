package com.ssafy.ggomalbe.common.entity;

import lombok.Builder;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import org.springframework.data.annotation.Id;
import org.springframework.data.relational.core.mapping.Column;
import org.springframework.data.relational.core.mapping.Table;

import java.time.ZonedDateTime;

@Table("schedule")
@Builder
public class ScheduleEntity extends AbstractEntity {
    @Id
    @Column("schedule_id")
    private final Long scheduleId;

    @Column("teacher_kid_id")
    private final Long teacherKidId;

    @Column("start_time")
    private final ZonedDateTime startTime;

    private final ScheduleEntity.Status status;

    @Getter
    @RequiredArgsConstructor
    public enum Status {
        TODO("시작 전"), PROGRESSING("진행 중"), DONE("완료");

        private final String description;
    }
}
