package com.ssafy.ggomalbe.common.entity;

import lombok.Builder;
import lombok.Getter;
import lombok.ToString;
import org.springframework.data.relational.core.mapping.Column;
import org.springframework.data.relational.core.mapping.Table;

@Table("chick_recognition")
@Builder
@ToString
@Getter
public class ChickRecognitionEntity {
    @Column(value = "origin_text")
    private final String originText;

    @Column(value = "recognition_scope")
    private final String recognitionScope;
}
