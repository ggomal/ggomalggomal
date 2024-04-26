package com.ssafy.ggomalbe.common.entity;

import lombok.Builder;
import lombok.Data;
import org.springframework.data.annotation.Id;
import org.springframework.data.relational.core.mapping.Column;
import org.springframework.data.relational.core.mapping.Table;

@Table("teacher_kid")
@Builder
@Data
public class TeacherKidEntity extends AbstractEntity {
    @Id
    @Column("teacher_kid_id")
    private final Long teacherKidId;

    @Column("teacher_id")
    private final Long teacherId;

    @Column("kid_id")
    private final Long kidId;
}
