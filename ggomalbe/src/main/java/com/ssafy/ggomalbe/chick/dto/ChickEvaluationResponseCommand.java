package com.ssafy.ggomalbe.chick.dto;

import com.ssafy.ggomalbe.common.entity.ChickRecordEntity;
import lombok.Builder;
import lombok.Data;

import java.util.List;

@Data
@Builder
public class ChickEvaluationResponseCommand {
    private String refWord;
    private Boolean overResult;
    private List<Boolean> words;

    private Long memberId;
    private Long gameNum;
    private Float score;
    private String pronunciation;

    public ChickEvaluationResponse toResponse(){
        return ChickEvaluationResponse.builder()
                .refWord(refWord)
                .overResult(overResult)
                .words(words)
                .build();
    }

    public ChickRecordEntity toEntity(){
        return ChickRecordEntity.builder()
                .memberId(memberId)
                .gameNum(gameNum)
                .score(score)
                .pronunciation(pronunciation)
                .build();
    }
}
