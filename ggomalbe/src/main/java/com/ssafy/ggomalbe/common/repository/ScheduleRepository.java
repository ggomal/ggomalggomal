package com.ssafy.ggomalbe.common.repository;

import com.ssafy.ggomalbe.common.entity.ScheduleEntity;
import com.ssafy.ggomalbe.schedule.dto.ScheduleGetCommand;
import com.ssafy.ggomalbe.schedule.dto.ScheduleListResponse;
import com.ssafy.ggomalbe.schedule.dto.ScheduleResponse;
import org.springframework.data.r2dbc.repository.Query;
import org.springframework.data.r2dbc.repository.R2dbcRepository;
import reactor.core.publisher.Flux;

import java.util.Objects;

public interface ScheduleRepository extends R2dbcRepository<ScheduleEntity, Long> {

    @Query("SELECT tk.kid_id as kid_id, m.name as kid_name, s.start_time as start_time, s.status as status, s.content as content " +
            "FROM schedule s " +
            "LEFT OUTER JOIN teacher_kid tk " +
            "ON s.teacher_kid_id = tk.teacher_kid_id " +
            "LEFT OUTER JOIN member m ON tk.kid_id = m.member_id " +
            "WHERE tk.teacher_id = :teacherId " +
            "AND tk.kid_id = :kidId " +
            "AND YEAR(s.start_time) = :year " +
            "AND MONTH(s.start_time) = :month;")
    Flux<ScheduleListResponse> findByCommand(Long teacherId, Long kidId, Integer year, Integer month);

    @Query("SELECT tk.kid_id as kid_id, m.name as kid_name, s.start_time as start_time, s.status as status " +
            "FROM schedule s " +
            "LEFT OUTER JOIN teacher_kid tk " +
            "ON s.teacher_kid_id = tk.teacher_kid_id " +
            "LEFT OUTER JOIN member m ON tk.kid_id = m.member_id " +
            "WHERE tk.teacher_id = :teacherId " +
            "AND YEAR(s.start_time) = :year " +
            "AND MONTH(s.start_time) = :month;")
    Flux<ScheduleListResponse> findByCommand(Long teacherId, Integer year, Integer month);
}
