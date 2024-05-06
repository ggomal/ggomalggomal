package com.ssafy.ggomalbe.homework;

import com.ssafy.ggomalbe.homework.dto.HomeworkResponse;
import reactor.core.publisher.Mono;

public interface HomeworkService {
    Mono<HomeworkResponse> doHomework(Long homeworkId);
    Mono<HomeworkResponse> undoHomework(Long homeworkId);
}
