package com.ssafy.ggomalbe.schedule.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.ssafy.ggomalbe.common.entity.ScheduleEntity;
import lombok.Builder;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@Builder
public class ScheduleListResponse {
    private Long kidId;
    private String kidName;
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd'T'HH:mm", timezone = "Asia/Seoul")
    private LocalDateTime startTime;
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd'T'HH:mm", timezone = "Asia/Seoul")
    private LocalDateTime endTime;
    private ScheduleEntity.Status status;
    private String content;
}
