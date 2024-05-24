package com.ssafy.ggomalbe.bear.dto;

import lombok.Builder;
import lombok.Data;

@Builder
@Data
public class WordRequest{

    private String letter;

    private String pronunciation;

    private String letterImgUrl;

    private String soundUrl;

    private Short syllable;

    private String initial;

    private String finality;


}
