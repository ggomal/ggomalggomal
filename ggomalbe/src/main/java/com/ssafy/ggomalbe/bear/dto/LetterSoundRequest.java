package com.ssafy.ggomalbe.bear.dto;

import lombok.Builder;
import lombok.Data;

@Builder
@Data
public class LetterSoundRequest {
    private String letter;
    private String soundUrl;
}
