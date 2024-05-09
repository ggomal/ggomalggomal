package com.ssafy.ggomalbe.member.kid;

import com.ssafy.ggomalbe.common.entity.KidEntity;
import com.ssafy.ggomalbe.common.entity.SituationKidEntity;
import com.ssafy.ggomalbe.common.entity.TeacherKidEntity;
import com.ssafy.ggomalbe.common.repository.KidRepository;
import com.ssafy.ggomalbe.common.repository.MemberRepository;
import com.ssafy.ggomalbe.common.repository.SituationKidRepository;
import com.ssafy.ggomalbe.common.repository.TeacherKidRepository;
import com.ssafy.ggomalbe.common.service.S3Service;
import com.ssafy.ggomalbe.member.kid.dto.*;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

@Service
@RequiredArgsConstructor
@Transactional
public class KidServiceImpl implements KidService {

    private final MemberRepository memberRepository;
    private final KidRepository kidRepository;
    private final TeacherKidRepository teacherKidRepository;
    private final SituationKidRepository situationKidRepository;
    private final S3Service s3Service;

    @Override
    public Mono<KidSignUpResponse> insertKid(KidSignUpRequest request) {
        return memberRepository.save(request.toMemberEntity())
                .map(memberEntity -> {
                    request.setMemberId(memberEntity.getMemberId());
                    return request;
                })
                .doOnSuccess(this::saveKid)
                .doOnSuccess(this::saveTeacherKid)
                .map(KidSignUpRequest::toKidSignUpResponse);
    }

    public void saveKid(KidEntity kid) {
        kidRepository.save(kid).subscribe();
        situationKidRepository.save(SituationKidEntity.builder()
                .memberId(kid.getMemberId())
                .situationId(1L)
                .build()).subscribe();
    }

    public void saveKid(KidSignUpRequest request) {
        saveKid(request.toKidEntity());
    }

    public void saveTeacherKid(TeacherKidEntity teacherKid) {
        teacherKidRepository.save(teacherKid).subscribe();
    }

    public void saveTeacherKid(KidSignUpRequest request) {
        saveTeacherKid(request.toTeacherKidEntity());
    }

    @Override
    public Mono<MemberKidResponse> getKid(Long memberId) {
        return memberRepository.getMemberKid(memberId);
    }

    public Flux<KidListResponse> getKidList(Long memberId) {
        System.out.println("get kids : i am teacher " + memberId);
        return memberRepository.getKidList(memberId);
    }

    @Override
    public Mono<CoinResponse> getOwnCoin(Long memberId) {
        return kidRepository.findById(memberId)
                .map(member -> CoinResponse.builder().coin(member.getCoin()).build());
    }

    @Override
    public Mono<Integer> setCoin(Long memberId, Long coin) {
        return kidRepository.setCoin(memberId, coin);
    }

    @Override
    public Mono<Integer> addCoin(Long memberId, Long coin) {
        if (coin == null)
            return Mono.empty();
        return kidRepository.addCoin(memberId, coin);
    }
}
