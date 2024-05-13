package com.ssafy.ggomalbe.schedule;

import com.ssafy.ggomalbe.common.entity.ScheduleEntity;
import com.ssafy.ggomalbe.schedule.dto.ScheduleAddRequest;
import com.ssafy.ggomalbe.schedule.dto.ScheduleResponse;
import com.ssafy.ggomalbe.schedule.dto.ScheduleSelectDto;

public class ScheduleMapper {

    public static ScheduleResponse toScheduleResponse(ScheduleSelectDto dto){
        return ScheduleResponse.builder()
                .kidId(dto.getKidId())
                .startTime(dto.getStartTime())
                .endTime(dto.getEndTime())
                .status(dto.getStatus())
                .build();
    }
    public static ScheduleResponse toScheduleResponse(ScheduleEntity entity, Long kidId){
        return ScheduleResponse.builder()
                .kidId(kidId)
                .startTime(entity.getStartTime())
                .endTime(entity.getEndTime())
                .status(entity.getStatus())
                .content(entity.getContent())
                .build();

    }

    public static ScheduleEntity toEntity(ScheduleAddRequest req, Long teacherKidId){
        return ScheduleEntity.builder()
                .teacherKidId(teacherKidId)
                .startTime(req.getStartTime())
                .endTime(req.getEndTime())
                .status(ScheduleEntity.Status.TODO)
                .content(req.getContent())
                .build();
    }
}
