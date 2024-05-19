package com.ssafy.ggomalbe.member.teacher;

import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;
import reactor.core.publisher.Mono;

@RestController
@RequestMapping("/teacher")
@RequiredArgsConstructor
public class TeacherController {
    private final TeacherService teacherService;
    @PostMapping
    public Mono<String> insertTeacher(@RequestBody String user, @RequestBody String password,
                                      @RequestBody String name, @RequestBody String phone){
        return teacherService.insertTeacher(user, password, name, phone);
    }

    @GetMapping("/{memberId}")
    public Mono<String> getTeacher(@PathVariable Long memberId){
        return teacherService.selectTeacher(memberId);
    }
}
