package com.ssafy.ggomalbe.common.entity;

import lombok.Builder;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import lombok.Setter;
import org.springframework.data.annotation.Id;
import org.springframework.data.relational.core.mapping.Column;
import org.springframework.data.relational.core.mapping.Table;

import java.time.LocalDateTime;

@Table("schedule")
@Builder
@Getter
public class ScheduleEntity extends AbstractEntity {
    @Id
    @Column("schedule_id")
    private final Long scheduleId;

    @Column("teacher_kid_id")
    private final Long teacherKidId;

    @Setter
    @Column("start_time")
    private LocalDateTime startTime;

    @Column("status")
    private ScheduleEntity.Status status;

    @Column("content")
    private String content;

    @Getter
    @RequiredArgsConstructor
    public enum Status {
        TODO("시작 전"), PROGRESSING("진행 중"), DONE("완료");

        private final String description;
    }

    public void setTODO(){this.status = Status.TODO;}
    public void setPROGRESSING(){this.status = Status.PROGRESSING;}
    public void setDONE(){this.status = Status.DONE;}

}
