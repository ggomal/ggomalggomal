package com.ssafy.ggomalbe.member.kid;

import com.ssafy.ggomalbe.common.entity.KidEntity;
import com.ssafy.ggomalbe.common.entity.MemberEntity;
import com.ssafy.ggomalbe.common.entity.TeacherKidEntity;
import com.ssafy.ggomalbe.common.repository.KidRepository;
import com.ssafy.ggomalbe.common.repository.MemberCustomRepository;
import com.ssafy.ggomalbe.common.repository.MemberRepository;
import com.ssafy.ggomalbe.common.repository.TeacherKidRepository;
import com.ssafy.ggomalbe.member.kid.dto.KidSignUpRequest;
import com.ssafy.ggomalbe.member.kid.dto.MemberKidResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import reactor.core.publisher.Mono;

@Service
@RequiredArgsConstructor
@Transactional
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
                .doOnSuccess(this::saveKid)
                .doOnSuccess(this::saveTeacherKid)
                .map(KidSignUpRequest::toMemberEntity);
    }
    public void saveKid(KidEntity kid){kidRepository.save(kid).subscribe();}
    public void saveKid(KidSignUpRequest request){saveKid(request.toKidEntity());}
    public void saveTeacherKid(TeacherKidEntity teacherKid){teacherKidRepository.save(teacherKid).subscribe();}
    public void saveTeacherKid(KidSignUpRequest request){saveTeacherKid(request.toTeacherKidEntity());}

    @Override
    public Mono<MemberKidResponse> getKid(Long memberId) {
        return memberCustomRepository.getMemberKid(memberId);
    }
}
