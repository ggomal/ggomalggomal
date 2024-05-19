package com.ssafy.ggomalbe.notice.dto;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@ToString
public class NoticeAddRequest {
    private Long kidId;
    private String contents;
    @Setter
    private String teacherName;
    private String[] homeworks;
}
