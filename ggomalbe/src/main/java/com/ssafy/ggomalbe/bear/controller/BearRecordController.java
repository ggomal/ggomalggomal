package com.ssafy.ggomalbe.bear.controller;

import com.ssafy.ggomalbe.bear.dto.BearRecordResponse;
import com.ssafy.ggomalbe.bear.dto.WordDto;
import com.ssafy.ggomalbe.bear.service.BearRecordService;
import com.ssafy.ggomalbe.common.entity.BearRecordEntity;
import com.ssafy.ggomalbe.common.entity.Word;
import com.ssafy.ggomalbe.common.service.GameNumService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.http.codec.multipart.FilePart;
import org.springframework.security.core.context.ReactiveSecurityContextHolder;
import org.springframework.web.bind.annotation.*;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

@RestController
@Slf4j
@RequiredArgsConstructor
@RequestMapping("/bear")
public class BearRecordController {
    private final BearRecordService bearRecordService;

    private final GameNumService gameNumService;

    @PostMapping("/evaluation")
    public Mono<BearRecordResponse> evaluation(@RequestPart("kidVoice") FilePart filePart, @RequestPart("gameNum") String gameNum, @RequestPart("wordId") String wordId, @RequestPart("letter") String letter, @RequestPart("pronCount") String pronCount){
        return ReactiveSecurityContextHolder.getContext()
                .map(securityContext ->
                        (Long) securityContext.getAuthentication().getDetails())
                .flatMap( memberId -> {
                    Long gameNumL = Long.parseLong(gameNum);
                    Long wordIdL = Long.parseLong(wordId);
                    Short pronCountS = Short.parseShort(pronCount);

                    return bearRecordService.addBearRecord(filePart, memberId,gameNumL,wordIdL,letter,pronCountS);
                });
    }
}
