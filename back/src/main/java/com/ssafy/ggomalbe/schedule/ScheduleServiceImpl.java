package com.ssafy.ggomalbe.schedule;

import com.ssafy.ggomalbe.common.repository.ScheduleRepository;
import com.ssafy.ggomalbe.common.repository.TeacherKidRepository;
import com.ssafy.ggomalbe.schedule.dto.ScheduleAddRequest;
import com.ssafy.ggomalbe.schedule.dto.ScheduleGetCommand;
import com.ssafy.ggomalbe.schedule.dto.ScheduleListResponse;
import com.ssafy.ggomalbe.schedule.dto.ScheduleResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

import java.time.LocalDate;

@Service
@Transactional
@RequiredArgsConstructor
public class ScheduleServiceImpl implements ScheduleService{
    private final ScheduleRepository scheduleRepository;
    private final TeacherKidRepository teacherKidRepository;

    @Override
    public Mono<ScheduleResponse> addSchedule(ScheduleAddRequest req, Long teacherId) {
        return teacherKidRepository.findByKidIdAndTeacherId(req.getKidId(), teacherId)
                .flatMap(teacherKid -> scheduleRepository.save(ScheduleMapper.toEntity(req, teacherKid.getTeacherKidId())))
                .map(scheduleEntity -> ScheduleMapper.toScheduleResponse(scheduleEntity, req.getKidId()))
                .doOnNext(res -> res.setMsg("SUCCESS"))
                .switchIfEmpty(Mono.just(ScheduleResponse.builder().msg("Check kidId").build()));
    }

    @Override
    public Flux<ScheduleListResponse> getAllSchedule(ScheduleGetCommand command) {
        LocalDate now = LocalDate.now();
        if (command.getKidId() != -1L) {
            return scheduleRepository.findByCommand(
                    command.getTeacherId(),
                    command.getKidId(),
                    command.getYear() == -1 ? now.getYear() : command.getYear(),
                    command.getMonth() == -1 ? now.getMonthValue() : command.getMonth());
        } else{
            return scheduleRepository.findByCommand(
                    command.getTeacherId(),
                    command.getYear() == -1 ? now.getYear() : command.getYear(),
                    command.getMonth() == -1 ? now.getMonthValue() : command.getMonth());
        }
    }
}
