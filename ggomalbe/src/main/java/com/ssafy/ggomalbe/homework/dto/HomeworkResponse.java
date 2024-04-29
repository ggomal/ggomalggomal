package com.ssafy.ggomalbe.homework.dto;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@ToString
@Setter
public class HomeworkResponse {
    private String homeworkContents;
    private Boolean isDone;
}
