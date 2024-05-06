package com.ssafy.ggomalbe.frog;

import com.ssafy.ggomalbe.frog.dto.FrogGameEndResponse;
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
    public Mono<FrogGameEndResponse> endFrogGame(@RequestBody FrogGameEndRequest request){
        return ReactiveSecurityContextHolder.getContext()
                .map(securityContext ->
                        (Long) securityContext.getAuthentication().getDetails())
                .flatMap(memberId -> frogService.setFrogGameRecord(memberId, request))
                .map(FrogGameEndResponse::new);
    }

}
