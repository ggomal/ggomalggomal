package com.ssafy.ggomalbe.whale;

import com.ssafy.ggomalbe.frog.FrogService;
import com.ssafy.ggomalbe.frog.dto.FrogGameEndRequest;
import com.ssafy.ggomalbe.frog.dto.FrogGameEndResponse;
import com.ssafy.ggomalbe.member.kid.KidService;
import com.ssafy.ggomalbe.whale.dto.WhaleEndRequest;
import com.ssafy.ggomalbe.whale.dto.WhaleEndResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.core.context.ReactiveSecurityContextHolder;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import reactor.core.publisher.Mono;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/whale")
public class WhaleController {

    private final KidService kidService;
    private final WhaleService whaleService;

    @PostMapping("/end")
    public Mono<WhaleEndResponse> endWhaleGame(@RequestBody WhaleEndRequest request){
        return ReactiveSecurityContextHolder.getContext()
                .map(securityContext ->
                        (Long) securityContext.getAuthentication().getDetails())
                .flatMap(memberId -> {  // 코인 획득 -> 게임 기록 저장
                    return kidService.addCoin(memberId, 1L)
                            .then(whaleService.setWhaleGameRecord(memberId, request));
                })
                .map(WhaleEndResponse::new);
    }

}
