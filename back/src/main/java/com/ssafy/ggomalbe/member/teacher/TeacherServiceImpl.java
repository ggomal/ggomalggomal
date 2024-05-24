package com.ssafy.ggomalbe.member.teacher;

import com.ssafy.ggomalbe.common.entity.MemberEntity;
import com.ssafy.ggomalbe.common.repository.MemberRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import reactor.core.publisher.Mono;

@Service
@Slf4j
@RequiredArgsConstructor
public class TeacherServiceImpl implements TeacherService{
    private final MemberRepository memberRepository;
    @Override
    public Mono<String> insertTeacher(String user, String password, String name, String phone) {
        MemberEntity teacher = MemberEntity.builder()
                .centerId(1L)
                .user(user)
                .password(password)
                .name(name)
                .phone(phone)
                .role(MemberEntity.Role.TEACHER)
                .build();
        return memberRepository.save(teacher)
                .map(MemberEntity::getName);
    }

    @Override
    public Mono<String> selectTeacher(Long memberId) {
        return memberRepository.findById(memberId)
                .map(MemberEntity::getName);
    }
}
