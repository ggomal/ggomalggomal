package com.ssafy.ggomalbe.common.entity;

import com.ssafy.ggomalbe.common.repository.HomeworkRepository;
import com.ssafy.ggomalbe.notice.dto.NoticeUpdateRequest;
import lombok.*;
import org.springframework.data.annotation.Id;
import org.springframework.data.annotation.Transient;
import org.springframework.data.relational.core.mapping.Column;
import org.springframework.data.relational.core.mapping.Table;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

import java.util.List;

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

    @Transient
    private List<HomeworkEntity> homeworks;

    public void update(NoticeUpdateRequest request){
        this.noticeId = request.getNoticeId();
        this.kidId = request.getKidId();
        this.noticeContents = request.getContents();
        this.teacherName = request.getTeacherName();
    }
}
