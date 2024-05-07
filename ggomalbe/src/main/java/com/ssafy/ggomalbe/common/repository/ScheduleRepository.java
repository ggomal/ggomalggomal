package com.ssafy.ggomalbe.common.repository;

import com.ssafy.ggomalbe.common.entity.ScheduleEntity;
import com.ssafy.ggomalbe.schedule.dto.ScheduleGetCommand;
import com.ssafy.ggomalbe.schedule.dto.ScheduleResponse;
import org.springframework.data.r2dbc.repository.Query;
import org.springframework.data.r2dbc.repository.R2dbcRepository;
import reactor.core.publisher.Flux;

public interface ScheduleRepository extends R2dbcRepository<ScheduleEntity, Long> {

    @Query("SELECT s.schedule_id ad scheduleId " +
            "s.start_time as startTime " +
            "s.status as status " +
            "tk.kid_id as kidId" +
            "FROM schedule " +
            "LEFT OUTER JOIN teacher_kid tk " +
            "ON s.teacher_kid_id = tk.teacher_kid_id " +
            "WHERE tk.teacher_id = :teacherId " +
            "AND tk.kid_id = :kid_id " +
            "AND YEAR(s.start_time) = :year " +
            "AND MONTH(s.start_time) = :month ;")
    Flux<ScheduleResponse> findByCommand(ScheduleGetCommand command);
}
