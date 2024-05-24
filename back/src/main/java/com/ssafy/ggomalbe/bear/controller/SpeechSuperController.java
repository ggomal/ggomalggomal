package com.ssafy.ggomalbe.bear.controller;

import com.ssafy.ggomalbe.common.dto.superspeech.PronunciationResDto;
import com.ssafy.ggomalbe.common.service.SpeechSuperService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.codec.multipart.FilePart;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.bind.annotation.RestController;
import reactor.core.publisher.Mono;

@RestController
@RequiredArgsConstructor
@RequestMapping("/speech")
public class SpeechSuperController {

    private final SpeechSuperService speechSuperService;

    @PostMapping
    public Mono<PronunciationResDto> evalSentence(@RequestPart("kidVoice") FilePart file, @RequestPart("letter")String text) {
        return speechSuperService.evaluation(file, text);
    }

}