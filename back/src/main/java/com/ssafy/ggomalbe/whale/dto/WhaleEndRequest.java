package com.ssafy.ggomalbe.whale.dto;


import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@AllArgsConstructor
@NoArgsConstructor
public class WhaleEndRequest {
    private float maxTime;
    private Long getCoin;
}
