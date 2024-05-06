package com.ssafy.ggomalbe.homework;

import com.ssafy.ggomalbe.homework.dto.HomeworkResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.core.context.ReactiveSecurityContextHolder;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import reactor.core.publisher.Mono;

import java.util.Map;

@Slf4j
@RestController
@RequestMapping("/homework")
@RequiredArgsConstructor
public class HomeworkController {
    private final HomeworkService homeworkService;

    @PutMapping("/do")
    public Mono<HomeworkResponse> doHomework(@RequestBody Map<String,Long> request) {
        return ReactiveSecurityContextHolder.getContext()
                .map(securityContext ->
                        (Long) securityContext.getAuthentication().getDetails())
                .flatMap(memberId -> homeworkService.doHomework(request.get("homeworkId")));
    }

    @PutMapping("/undo")
    public Mono<HomeworkResponse> undoHomework(@RequestBody Map<String,Long> request){
        return ReactiveSecurityContextHolder.getContext()
                .map(securityContext ->
                        (Long) securityContext.getAuthentication().getDetails())
                .flatMap(memberId -> homeworkService.undoHomework(request.get("homeworkId")));
    }
}
