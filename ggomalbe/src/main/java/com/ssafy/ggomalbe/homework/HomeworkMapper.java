package com.ssafy.ggomalbe.homework;

import com.ssafy.ggomalbe.common.entity.HomeworkEntity;
import com.ssafy.ggomalbe.homework.dto.HomeworkResponse;

public class HomeworkMapper {
    public static HomeworkResponse toHomeworkResponse(HomeworkEntity entity){
        return HomeworkResponse.builder()
                .homework_id(entity.getHomeworkId())
                .homeworkContents(entity.getHomeworkContents())
                .isDone(entity.getIsDone())
                .build();
    }
}
