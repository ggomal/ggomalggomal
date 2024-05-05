package com.ssafy.ggomalbe.bear.dto;

import lombok.*;

import java.util.List;
import java.util.Set;

@Getter
@Setter
@AllArgsConstructor
@RequiredArgsConstructor
@Builder
public class WordCategoryRequest {
    private Set<String> initialList;
    private Set<Short> syllableList;
}
