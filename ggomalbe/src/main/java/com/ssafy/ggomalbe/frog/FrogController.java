package com.ssafy.ggomalbe.frog;

import com.ssafy.ggomalbe.common.entity.FrogRecordEntity;
import com.ssafy.ggomalbe.frog.dto.EndGameResponse;
import com.ssafy.ggomalbe.frog.dto.FrogGameEndRequest;
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
@RequestMapping("/frog")
public class FrogController {

    private final FrogService frogService;

    @PostMapping("/end")
    public Mono<EndGameResponse> endFrogGame(@RequestBody FrogGameEndRequest request){
        return ReactiveSecurityContextHolder.getContext()
                .map(securityContext ->
                        (Long) securityContext.getAuthentication().getDetails())
                .flatMap(memberId -> frogService.setGameRecord(memberId, request))
//                .map(entity -> entity.getFrogRecordId()!=null ? true : false)
                .map(EndGameResponse::new);
    }

}
