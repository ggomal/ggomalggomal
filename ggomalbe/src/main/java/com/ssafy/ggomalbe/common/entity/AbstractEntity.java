package com.ssafy.ggomalbe.common.entity;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.LastModifiedDate;
import org.springframework.data.annotation.Transient;
import org.springframework.data.relational.core.mapping.Column;
import org.springframework.data.repository.core.EntityInformation;

import java.time.LocalDateTime;
import java.time.ZonedDateTime;

@Getter
@ToString
public abstract class AbstractEntity {
    @CreatedDate
    private LocalDateTime createdAt;

    @LastModifiedDate
    private LocalDateTime modifiedAt;

    @Column("deleted_at")
    private LocalDateTime deletedAt;

}
