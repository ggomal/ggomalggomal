package com.ssafy.ggomalbe.common.entity;

import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.LastModifiedDate;
import org.springframework.data.relational.core.mapping.Column;

import java.time.LocalDateTime;
import java.time.ZonedDateTime;

public class AbstractEntity {
    @CreatedDate
    @Column("created_at")
    private ZonedDateTime createdAt;

    @LastModifiedDate
    @Column("modified_at")
    private ZonedDateTime modifiedAt;

    @Column("deleted_at")
    private ZonedDateTime deletedAt;
}
