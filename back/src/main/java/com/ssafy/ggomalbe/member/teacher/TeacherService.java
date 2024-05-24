package com.ssafy.ggomalbe.member.teacher;

import reactor.core.publisher.Mono;

public interface TeacherService {
    Mono<String> insertTeacher(String user, String password, String name, String phone);
    Mono<String> selectTeacher(Long memberId);
}
