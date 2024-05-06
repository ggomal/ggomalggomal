package com.ssafy.ggomalbe.bear.controller;

import com.ssafy.ggomalbe.bear.service.BearRecordService;
import com.ssafy.ggomalbe.common.service.GameNumService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.codec.multipart.FilePart;
import org.springframework.web.bind.annotation.*;
import reactor.core.publisher.Mono;

import java.util.Locale;
import java.util.Map;

@RestController
@Slf4j
@RequiredArgsConstructor
@RequestMapping("/bear")
public class BearRecordController {
    private final BearRecordService bearRecordService;

    private final GameNumService gameNumService;
    @PostMapping("/test")
    public Mono<Map<String, String>> test(@RequestPart("kidVoice") FilePart filePart, @RequestPart("gameNum") String gameNum,@RequestPart("wordId") String wordId, @RequestPart("letter") String letter, @RequestPart("pronCount") String pronCount){
        log.info("{}",filePart.toString());
        log.info("{}",letter);
        log.info("{}",wordId);
        log.info("{}",pronCount);

        return bearRecordService.evaluate(filePart,letter);
    }

    //게임카운터들고오고 1증가시켜서 저장

    @GetMapping("/ttt")
    public Mono<Long> ttt(){
        return gameNumService.getIncrementGameCount();
    }

}
