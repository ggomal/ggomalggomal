package com.ssafy.ggomalbe.bear.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;
import org.springframework.web.bind.annotation.GetMapping;

import java.util.Map;

@Getter
@Setter
@AllArgsConstructor
public class OpenApiResponse {
    private double result;
    private String return_type;
    private Map<String, String> return_object;

    @Override
    public String toString() {
        return "OpenApiResponse{" +
                "result=" + result +
                ", return_type='" + return_type + '\'' +
                ", return_object=" + return_object +
                '}';
    }
}
