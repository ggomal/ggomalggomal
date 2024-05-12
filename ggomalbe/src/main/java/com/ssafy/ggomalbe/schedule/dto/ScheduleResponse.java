package com.ssafy.ggomalbe.schedule.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.ssafy.ggomalbe.common.entity.ScheduleEntity;
import lombok.Builder;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
import reactor.core.publisher.Mono;

import java.time.LocalDateTime;

@Getter
@ToString
@Setter
@Builder
public class ScheduleResponse {
    private Long kidId;
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd'T'HH:mm", timezone = "Asia/Seoul")
    private LocalDateTime startTime;
    private ScheduleEntity.Status status;
    private String content;
    private String msg;
}
