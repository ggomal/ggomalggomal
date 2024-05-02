package com.ssafy.ggomalbe.member.kid;

import com.ssafy.ggomalbe.common.entity.KidEntity;
import com.ssafy.ggomalbe.common.entity.MemberEntity;
import com.ssafy.ggomalbe.common.repository.KidRepository;
import com.ssafy.ggomalbe.common.repository.MemberCustomRepository;
import com.ssafy.ggomalbe.common.repository.MemberRepository;
import com.ssafy.ggomalbe.member.kid.dto.MemberKidResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import reactor.core.publisher.Mono;

@Service
@RequiredArgsConstructor
public class KidServiceImpl implements KidService{

    private final MemberRepository memberRepository;
    private final KidRepository kidRepository;

    private final MemberCustomRepository memberCustomRepository;

    @Override
    public Mono<MemberEntity> insertKid() {
        return null;
    }

    @Override
    public Mono<MemberKidResponse> getKid(Long memberId) {
        return memberCustomRepository.getMemberKid(memberId);
    }
}
