package com.ssafy.ggomalbe.member.kid;

import com.ssafy.ggomalbe.common.dto.Base64ImageDto;
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
import reactor.core.scheduler.Schedulers;

import java.nio.ByteBuffer;

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
                .publishOn(Schedulers.boundedElastic())
//                .map(req->{
//                    Base64ImageDto base64Data = new Base64ImageDto(req.getUser(), req.getImg());
//                    s3Service.uploadHandler(base64Data.getFileName(), Mono.fromCallable(base64Data::getByteBuffer))
//                            .subscribe();
//                    return req;
//                })
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
        return kidRepository.findByMemberId(memberId)
                .map(member -> CoinResponse.builder().coin(member.getCoin()).build());
    }

    @Override
    public Mono<Integer> setCoin(Long memberId, Long coin) {
        return kidRepository.setCoin(memberId, coin);
    }

    public Mono<Integer> minusCoin(Long memberId, Long coin){
        if (coin == null)
            return Mono.empty();
        return kidRepository.minusCoin(memberId, coin);
    }


    @Override
    public Mono<Integer> addCoin(Long memberId, Long coin) {
        if (coin == null)
            return Mono.empty();
        return kidRepository.addCoin(memberId, coin);
    }

    @Override
    public Flux<TeacherKidEntity> findByKidId(Long kidId){
        return teacherKidRepository.findByKidId(kidId);
    }
}
