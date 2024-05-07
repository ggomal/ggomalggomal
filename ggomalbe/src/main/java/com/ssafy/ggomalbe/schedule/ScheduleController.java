package com.ssafy.ggomalbe.schedule;

import com.ssafy.ggomalbe.schedule.dto.ScheduleAddRequest;
import com.ssafy.ggomalbe.schedule.dto.ScheduleGetCommand;
import com.ssafy.ggomalbe.schedule.dto.ScheduleResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.context.ReactiveSecurityContextHolder;
import org.springframework.web.bind.annotation.*;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

import java.util.List;

@RestController
@RequestMapping("/schedule")
@RequiredArgsConstructor
public class ScheduleController {
    private final ScheduleService scheduleService;

    @PostMapping
    public Mono<ScheduleResponse> addSchedule(@RequestBody ScheduleAddRequest req) {
        return ReactiveSecurityContextHolder.getContext()
                .map(securityContext ->
                        (Long) securityContext.getAuthentication().getDetails())
                .flatMap(teacherId -> scheduleService.addSchedule(req, teacherId));
    }

    @GetMapping
    public Mono<List<ScheduleResponse>> getAllSchedule(@RequestParam(required = false, defaultValue = "-1") Long kidId,
                                                       @RequestParam(required = false, defaultValue = "-1") Integer year,
                                                       @RequestParam(required = false, defaultValue = "-1") Integer month) {
        return ReactiveSecurityContextHolder.getContext()
                .map(securityContext ->
                        (Long) securityContext.getAuthentication().getDetails())
                .flatMap(teacherId ->
                        scheduleService.getAllSchedule(
                                        ScheduleGetCommand.builder()
                                                .teacherId(teacherId)
                                                .kidId(kidId)
                                                .year(year)
                                                .month(month)
                                                .build())
                                .sort((r1, r2) ->
                                        (r1.getStartTime().isAfter(r2.getStartTime()) ? 1 :
                                                (r1.getStartTime().isEqual(r2.getStartTime()) ? 0 : -1)))
                                .collectList()
                );
    }
}
