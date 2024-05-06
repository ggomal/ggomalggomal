package com.ssafy.ggomalbe.notice.dto;

import com.ssafy.ggomalbe.common.entity.NoticeEntity;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@ToString
@Setter
public class NoticeAddResponse {
    private final Long noticeId;
    private final Long kidId;
    private final String contents;
    private final String teacherName;
    private String[] homeworks;
    private String msg;

    public NoticeAddResponse(NoticeEntity notice, String[] homeworks) {
        this.noticeId = notice.getNoticeId();
        this.kidId = notice.getKidId();
        this.contents = notice.getNoticeContents();
        this.teacherName = notice.getTeacherName();
        this.homeworks = homeworks;
    }
}
