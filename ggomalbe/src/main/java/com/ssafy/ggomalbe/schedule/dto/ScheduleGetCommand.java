package com.ssafy.ggomalbe.schedule.dto;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class ScheduleGetCommand {
    private Long kidId;
    private Long teacherId;
    private Integer year;
    private Integer month;
}
