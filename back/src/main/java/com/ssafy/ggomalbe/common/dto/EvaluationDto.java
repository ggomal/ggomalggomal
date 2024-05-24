package com.ssafy.ggomalbe.common.dto;


import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.RequiredArgsConstructor;

import java.util.HashMap;
import java.util.Map;

@Data
@AllArgsConstructor
@RequiredArgsConstructor
@Builder
public class EvaluationDto {

//    Map<String, String> result = new HashMap<>();
//                                        result.put("pronunciation", sttText);
//                                        result.put("score", returnObject.get("score"));
//                                        result.put("letter", letter);
//                                        return result;

       private String pronunciation;
       private float score;
       private String originText;

}
