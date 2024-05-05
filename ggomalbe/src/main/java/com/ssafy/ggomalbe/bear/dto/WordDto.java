package com.ssafy.ggomalbe.bear.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class WordDto {
    String letter;
    String pronunciation;
    String initial;
    Short syllable;
    boolean finalityFlag;
    String letterImgUrl;
    String soundUrl;

}