package com.ssafy.ggomalbe.notice.dto;

import com.ssafy.ggomalbe.common.entity.NoticeEntity;
import com.ssafy.ggomalbe.homework.dto.HomeworkResponse;
import lombok.Builder;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

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

    private List<HomeworkResponse> homeworks = new ArrayList<>();

    public NoticeEntity toEntity(){
        return NoticeEntity.builder()
                .noticeId(noticeId)
                .teacherName(teacherName)
                .noticeContents(content)
                .build();
    }
}
