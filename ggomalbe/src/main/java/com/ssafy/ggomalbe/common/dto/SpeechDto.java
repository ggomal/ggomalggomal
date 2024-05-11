package com.ssafy.ggomalbe.common.dto;

import lombok.*;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.GetMapping;

import java.util.Map;

@Getter
@Setter
@ToString
@AllArgsConstructor
@NoArgsConstructor
public class SpeechDto {
    private Integer pronunciation;

//    private Map<String,String> result;
}
