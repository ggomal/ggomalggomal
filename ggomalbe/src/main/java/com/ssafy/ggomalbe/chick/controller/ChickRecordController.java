package com.ssafy.ggomalbe.chick.controller;


import com.ssafy.ggomalbe.bear.service.RoomService;
import com.ssafy.ggomalbe.chick.service.ChickRecordService;
import com.ssafy.ggomalbe.common.entity.BearRecordEntity;
import com.ssafy.ggomalbe.common.entity.ChickRecordEntity;
import com.ssafy.ggomalbe.common.service.GameNumService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.codec.multipart.FilePart;
import org.springframework.security.core.context.ReactiveSecurityContextHolder;
import org.springframework.web.bind.annotation.*;
import reactor.core.publisher.Mono;

@RestController
@RequestMapping("chick-record")
@Slf4j
@RequiredArgsConstructor
public class ChickRecordController {
    private final ChickRecordService chickRecordService;
    private final GameNumService gameNumService;
    private final RoomService roomService;

    @PostMapping("/evaluation")
    public Mono<ChickRecordEntity> evaluation(@RequestPart("kidVoice") FilePart filePart, @RequestPart("gameNum") String gameNum, @RequestPart("sentence") String sentence){
        return ReactiveSecurityContextHolder.getContext()
                .map(securityContext ->
                        (Long) securityContext.getAuthentication().getDetails())
                .flatMap( memberId -> {
                    Long gameNumL = Long.parseLong(gameNum);

                    return chickRecordService.addChickRecord(filePart, memberId,gameNumL, sentence);
                });
    }

    @GetMapping("/gameNum")
    public Mono<Long> getGameNum(){
        return gameNumService.getIncrementGameCount();
    }

    //음성 -> 텍스트로바꾸기
    //정답 ("헴 넣어")랑 비교하기
    //"햄,해" 가 있거나, "넣어, 너어, 너, 누어" 가 있으면 통과
    //하나의 조건이라도 만족하지 못하면 틀린 부분을(없는 부분을) 전송
    //예시 -> "햅 넣어 " compare "햄 노아" -> isPass : false, ["넣","어"]

    @GetMapping("/analyzing")
    public Mono<Void> analyzing(){
//        log.info("{}", roomService);
        return Mono.empty();
    }
}
