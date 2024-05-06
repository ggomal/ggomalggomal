package com.ssafy.ggomalbe.notice.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.ssafy.ggomalbe.common.entity.NoticeEntity;
import com.ssafy.ggomalbe.homework.dto.HomeworkResponse;
import lombok.Builder;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Getter
@ToString
@Setter
@Builder
public class NoticeResponse {
    private Long noticeId;
    private String teacherName;
    private String content;
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd", timezone = "Asia/Seoul")
    private LocalDateTime date;
    private List<HomeworkResponse> homeworks;
    public NoticeResponse setHomeworks(List<HomeworkResponse> homeworks){
        this.homeworks = homeworks;
        return this;
    }
}
