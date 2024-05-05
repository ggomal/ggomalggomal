package com.ssafy.ggomalbe.bear.dto;

import com.ssafy.ggomalbe.common.entity.AbstractEntity;
import lombok.Builder;
import lombok.Data;
import lombok.Setter;
import org.springframework.data.relational.core.mapping.Table;

@Builder
@Data
public class WordRequest{

    private String letter;

    private String pronunciation;

    private String letterImgUrl;

    private String soundUrl;

    private String initial;

    private Short syllable;

    private Boolean finalityFlag;



}
