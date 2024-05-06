package com.ssafy.ggomalbe.bear.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.Id;
import org.springframework.data.relational.core.mapping.Column;

@NoArgsConstructor
@AllArgsConstructor
@Data
@Builder
public class BearRecordResponse {
    private Long bearRecordId;

    private Long memberId;

    private Long wordId;

    private Long gameNum;

    private String pronunciation;

    private Short pronCount;

    private Float score;
}
