package com.ssafy.ggomalbe.common.dto.superspeech;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import lombok.Data;

@Data
public class ResultResDto {
    private int overall;                //전체 점수
    private int pronunciation;          //발음 점수
    private int fluency;                //유창 점수
    private int integrity;              //완전성 점수
    private int rhythm;                 //리듬 점수(음조와 강세)
    private WordResDto[] words;         //단어 점수
    private WarnResDto warn;
    private int errorId;
    private String error;
}