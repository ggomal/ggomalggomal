package com.ssafy.ggomalbe.bear.dto;

import lombok.*;

import java.util.List;

@Getter
@Setter
@AllArgsConstructor
@RequiredArgsConstructor
@Builder
public class WordCategoryResponse {
    private List<String> initialList;
    private Short syllable;
    private boolean finalityFlag;
}
