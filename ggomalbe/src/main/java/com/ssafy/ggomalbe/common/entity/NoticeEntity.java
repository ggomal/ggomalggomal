package com.ssafy.ggomalbe.common.entity;

import com.ssafy.ggomalbe.notice.dto.NoticeUpdateRequest;
import lombok.Builder;
import lombok.Data;
import lombok.Getter;
import org.springframework.data.annotation.Id;
import org.springframework.data.relational.core.mapping.Column;
import org.springframework.data.relational.core.mapping.Table;

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

    public void update(NoticeUpdateRequest request){
        this.noticeId = request.getNoticeId();
        this.kidId = request.getKidId();
        this.noticeContents = request.getContents();
        this.teacherName = request.getTeacherName();
    }
}
