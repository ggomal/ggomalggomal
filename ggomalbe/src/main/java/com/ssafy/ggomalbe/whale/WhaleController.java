package com.ssafy.ggomalbe.whale;

import com.ssafy.ggomalbe.common.service.GameNumService;
import com.ssafy.ggomalbe.member.kid.KidService;
import com.ssafy.ggomalbe.whale.dto.WhaleEndRequest;
import com.ssafy.ggomalbe.whale.dto.WhaleEndResponse;
import com.ssafy.ggomalbe.whale.dto.WhaleEvaluationResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.codec.multipart.FilePart;
import org.springframework.security.core.context.ReactiveSecurityContextHolder;
import org.springframework.web.bind.annotation.*;
import reactor.core.publisher.Mono;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/whale")
public class WhaleController {

    private final KidService kidService;
    private final WhaleService whaleService;
    private final GameNumService gameNumService;

    @PostMapping("/end")
    public Mono<WhaleEndResponse> endWhaleGame(@RequestBody WhaleEndRequest request){
        return ReactiveSecurityContextHolder.getContext()
                .map(securityContext ->
                        (Long) securityContext.getAuthentication().getDetails())
                .flatMap(memberId -> {  // 코인 획득 -> 게임 기록 저장
                    return kidService.addCoin(memberId, request.getGetCoin())
                            .then(whaleService.setWhaleGameRecord(memberId, request));
                })
                .map(WhaleEndResponse::new);
    }


    @PostMapping("/evaluation")
    public Mono<WhaleEvaluationResponse> evaluation(@RequestPart("kidVoice") FilePart filePart,
                                                    @RequestPart("sentence") String sentence) {
        return ReactiveSecurityContextHolder.getContext()
                .map(securityContext ->
                        (Long) securityContext.getAuthentication().getDetails())
                .flatMap(memberId -> whaleService.evaluationWhale(filePart, memberId, sentence))
                .map(dto ->{
                    return WhaleEvaluationResponse.builder()
                            .refSentence(dto.getRefSentence())
                            .allResult(dto.getAllResult())
                            .wordResult(dto.getWordResult())
                            .build();
                });
    }

//    @PostMapping("/evaluation")
//    public Mono<WhaleEvaluationResponse> evaluation(@RequestPart("kidVoice") FilePart filePart,
//                                                    @RequestPart("gameNum") String gameNum,
//                                                    @RequestPart("sentence") String sentence) {
//        return ReactiveSecurityContextHolder.getContext()
//                .map(securityContext ->
//                        (Long) securityContext.getAuthentication().getDetails())
//                .flatMap(memberId -> whaleService.evaluationWhale(filePart, memberId, Long.valueOf(gameNum), sentence))
//                .flatMap(resC -> {
//                    return Mono.fromRunnable(() -> {
//                                whaleService.setChickGameRecord(resC.toEntity()).subscribe();
//                            }).subscribeOn(Schedulers.boundedElastic())
//                            .thenReturn(resC.toResponse());
//                });
//    }

    @GetMapping("/gameNum")
    public Mono<Long> getGameNum() {
        return gameNumService.getIncrementGameCount();
    }


}
