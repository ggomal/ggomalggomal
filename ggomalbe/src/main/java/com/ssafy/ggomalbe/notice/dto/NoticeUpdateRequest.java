package com.ssafy.ggomalbe.notice.dto;

import lombok.Getter;
import lombok.ToString;

@Getter
@ToString
public class NoticeUpdateRequest {
    private Long noticeId;
    private String contents;
    private String[] homeworks;
}
