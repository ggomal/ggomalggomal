package com.ssafy.ggomalbe.common.entity;

import lombok.Builder;
import lombok.Data;
import org.springframework.data.annotation.Id;
import org.springframework.data.relational.core.mapping.Column;
import org.springframework.data.relational.core.mapping.Table;

@Table("word")
@Builder
@Data
public class WordEntity extends AbstractEntity {
    @Id
    @Column("word_id")
    private final Long wordId;

    private final String letter;

    @Column("letter_img_url")
    private final String letterImgUrl;

    @Column("sound_url")
    private final String soundUrl;

    private final String initial;

    private final Short syllable;

    @Column("finality_flag")
    private final Boolean finalityFlag;
}
