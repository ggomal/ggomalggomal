package com.ssafy.ggomalbe.homework.dto;

import com.ssafy.ggomalbe.common.entity.NoticeEntity;
import lombok.Builder;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
import org.springframework.data.annotation.Transient;

@Getter
@ToString
@Setter
@Builder
public class HomeworkResponse {
    private Long homework_id;
    private String homeworkContents;
    private Boolean isDone;
}
