package com.ssafy.ggomalbe.member.kid;

import com.ssafy.ggomalbe.common.entity.KidEntity;
import com.ssafy.ggomalbe.common.entity.MemberEntity;
import com.ssafy.ggomalbe.common.repository.KidRepository;
import com.ssafy.ggomalbe.common.repository.MemberCustomRepository;
import com.ssafy.ggomalbe.common.repository.MemberRepository;
import com.ssafy.ggomalbe.common.repository.TeacherKidRepository;
import com.ssafy.ggomalbe.member.dto.KidSignUpRequest;
import com.ssafy.ggomalbe.member.kid.dto.MemberKidResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import reactor.core.publisher.Mono;
import reactor.core.scheduler.Schedulers;

@Service
@RequiredArgsConstructor
public class KidServiceImpl implements KidService{

    private final MemberRepository memberRepository;
    private final KidRepository kidRepository;
    private final TeacherKidRepository teacherKidRepository;

    private final MemberCustomRepository memberCustomRepository;

    @Override
    public Mono<MemberEntity> insertKid(KidSignUpRequest request) {
        return memberRepository.save(request.toMemberEntity())
                .map(memberEntity -> {
                    request.setMemberId(memberEntity.getMemberId());
                    return request;
                })
                .publishOn(Schedulers.boundedElastic())
                .flatMap(req -> kidRepository.save(req.toKidEntity())
                        .map(kidEntity -> req))
                .flatMap(req -> teacherKidRepository.save(req.toTeacherKidEntity())
                        .map(teacherKidEntity -> req))
                .map(KidSignUpRequest::toMemberEntity);
    }

    @Override
    public Mono<MemberKidResponse> getKid(Long memberId) {
        return memberCustomRepository.getMemberKid(memberId);
    }
}
