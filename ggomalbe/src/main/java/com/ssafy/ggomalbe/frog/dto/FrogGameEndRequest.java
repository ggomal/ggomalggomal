package com.ssafy.ggomalbe.frog.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@AllArgsConstructor
@NoArgsConstructor
public class FrogGameEndRequest {
    // 일단 플레이타임만 저장
    private Float playTime;

    private Float durationSec;   // 최대 혀 내민 시간

    private Float length;   // 최대 혀 내민 길이

}
