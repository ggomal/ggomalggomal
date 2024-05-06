package com.ssafy.ggomalbe.schedule.dto;

import com.ssafy.ggomalbe.common.entity.ScheduleEntity;
import lombok.Builder;
import lombok.Data;
import lombok.Setter;
import org.springframework.data.relational.core.mapping.Column;

import java.time.LocalDateTime;

@Builder
@Data
public class ScheduleSelectDto {
    private final Long scheduleId;
    private final Long teacherKidId;
    private final LocalDateTime startTime;
    private final ScheduleEntity.Status status;
    private final Long kidId;
    private final Long teacherId;
}
