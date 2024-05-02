package com.ssafy.ggomalbe.notice.dto;

import lombok.Getter;
import lombok.ToString;

@Getter
@ToString
public class NoticeAddRequest {
    private String contents;
    private String teacherName;
    private String[] homeworks;
}
