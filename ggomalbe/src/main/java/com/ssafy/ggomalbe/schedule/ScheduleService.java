package com.ssafy.ggomalbe.schedule;

import com.ssafy.ggomalbe.schedule.dto.ScheduleAddRequest;
import com.ssafy.ggomalbe.schedule.dto.ScheduleGetCommand;
import com.ssafy.ggomalbe.schedule.dto.ScheduleListResponse;
import com.ssafy.ggomalbe.schedule.dto.ScheduleResponse;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

public interface ScheduleService {
    Mono<ScheduleResponse> addSchedule(ScheduleAddRequest req, Long teacherId);

    Flux<ScheduleListResponse> getAllSchedule(ScheduleGetCommand command);
}
