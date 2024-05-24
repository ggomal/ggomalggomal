package com.ssafy.ggomalbe.notice;

import com.ssafy.ggomalbe.common.entity.NoticeEntity;
import com.ssafy.ggomalbe.notice.dto.NoticeResponse;
import io.r2dbc.spi.Row;
import io.r2dbc.spi.RowMetadata;
import org.springframework.data.relational.core.sql.Not;

import java.util.ArrayList;
import java.util.function.BiFunction;

public class NoticeMapper  {

    public static NoticeResponse toNoticeResponse(NoticeEntity notice) {
        return NoticeResponse.builder()
                .noticeId(notice.getNoticeId())
                .teacherName(notice.getTeacherName())
                .content(notice.getNoticeContents())
                .date(notice.getCreatedAt())
                .homeworks(new ArrayList<>())
                .build();
    }
}
