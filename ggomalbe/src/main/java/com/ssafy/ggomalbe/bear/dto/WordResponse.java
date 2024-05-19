package com.ssafy.ggomalbe.bear.dto;

import lombok.Builder;
import lombok.Data;
import org.springframework.data.annotation.Id;
import org.springframework.data.relational.core.mapping.Column;
import org.springframework.data.relational.core.mapping.Table;

@Builder
@Data
public class WordResponse {
    private final Long wordId;

    private final String letter;

    private final String pronunciation;

    private final String letterImgUrl;

    private final String soundUrl;

    private final String initial;

    private final Short syllable;

    private final Boolean finalityFlag;
}
