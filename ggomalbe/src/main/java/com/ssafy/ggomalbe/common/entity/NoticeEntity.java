package com.ssafy.ggomalbe.common.entity;

import com.ssafy.ggomalbe.notice.dto.NoticeUpdateRequest;
import lombok.Builder;
import lombok.Data;
import lombok.Getter;
import org.springframework.data.annotation.Id;
import org.springframework.data.relational.core.mapping.Column;
import org.springframework.data.relational.core.mapping.Table;
import org.springframework.util.StringUtils;

@Table("notice")
@Builder
@Getter
@Data
public class NoticeEntity extends AbstractEntity {
    @Id
    @Column("notice_id")
    private Long noticeId;

    @Column("kid_id")
    private Long kidId;

    @Column("notice_contents")
    private String noticeContents;

    @Column("teacher_name")
    private String teacherName;

    public void updateContent(String noticeContents){
        if (StringUtils.hasLength(noticeContents)) this.noticeContents = noticeContents;
    }
}
