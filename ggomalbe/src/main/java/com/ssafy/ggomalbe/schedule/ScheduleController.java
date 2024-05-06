package com.ssafy.ggomalbe.schedule;

import com.ssafy.ggomalbe.schedule.dto.ScheduleAddRequest;
import com.ssafy.ggomalbe.schedule.dto.ScheduleResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.context.ReactiveSecurityContextHolder;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import reactor.core.publisher.Mono;

@RestController
@RequestMapping("/schedule")
@RequiredArgsConstructor
public class ScheduleController {
    private final ScheduleService scheduleService;

    @PostMapping
    public Mono<ScheduleResponse> addSchedule(@RequestBody ScheduleAddRequest req){
        return ReactiveSecurityContextHolder.getContext()
                .map(securityContext ->
                        (Long) securityContext.getAuthentication().getDetails())
                .flatMap(teacherId -> scheduleService.addSchedule(req, teacherId));
    }
}
