package com.ssafy.ggomalbe.schedule.dto;

import lombok.Data;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.time.LocalDateTime;

@Getter
@ToString
public class ScheduleAddRequest {
    private Long kidId;
    private LocalDateTime startTime;
}
