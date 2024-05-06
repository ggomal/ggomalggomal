package com.ssafy.ggomalbe.chick.controller;


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

    @PostMapping("/evaluation")
    public Mono<ChickRecordEntity> evaluation(@RequestPart("kidVoice") FilePart filePart, @RequestPart("gameNum") String gameNum, @RequestPart("letter") String sentence){
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
}
