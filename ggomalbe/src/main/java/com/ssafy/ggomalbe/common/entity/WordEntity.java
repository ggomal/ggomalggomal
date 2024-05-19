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

    private final String pronunciation;

    private final Short syllable;

    private final String initial;

    @Column("finality")
    private final String finality;

    @Column("letter_img_url")
    private final String letterImgUrl;

    @Column("sound_url")
    private final String soundUrl;
}
