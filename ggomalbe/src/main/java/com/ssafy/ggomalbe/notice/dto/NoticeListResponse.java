package com.ssafy.ggomalbe.notice.dto;

import lombok.Builder;
import lombok.Getter;
import lombok.ToString;

import java.time.LocalDateTime;

@Getter
@ToString
@Builder
public class NoticeListResponse {
    private final Long noticeId;
    private final LocalDateTime date;

}
