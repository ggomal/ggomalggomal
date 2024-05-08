package com.ssafy.ggomalbe.chick.controller;


import com.ssafy.ggomalbe.bear.service.RoomService;
import com.ssafy.ggomalbe.chick.dto.*;
import com.ssafy.ggomalbe.chick.service.ChickRecordService;
import com.ssafy.ggomalbe.common.entity.BearRecordEntity;
import com.ssafy.ggomalbe.common.entity.ChickRecordEntity;
import com.ssafy.ggomalbe.common.entity.MemberEntity;
import com.ssafy.ggomalbe.common.service.GameNumService;
import com.ssafy.ggomalbe.member.kid.KidService;
import io.swagger.v3.oas.annotations.Operation;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.http.codec.multipart.FilePart;
import org.springframework.security.core.context.ReactiveSecurityContextHolder;
import org.springframework.web.bind.annotation.*;
import reactor.core.publisher.Mono;
import reactor.core.scheduler.Schedulers;

import java.util.List;

@RestController
@RequestMapping("chick")
@Slf4j
@RequiredArgsConstructor
public class ChickRecordController {
    private final KidService kidService;
    private final ChickRecordService chickRecordService;
    private final GameNumService gameNumService;
    private final RoomService roomService;

    @PostMapping("/evaluation")
    public Mono<ResponseEntity<ChickEvaluationResponse>> evaluation(@RequestPart("kidVoice") FilePart filePart,
                                                                    @RequestPart("gameNum") String gameNum,
                                                                    @RequestPart("sentence") String sentence) {
        return chickRecordService.checkSentence(filePart, sentence)
                .map(aBoolean ->
                        ResponseEntity.ok(
                                ChickEvaluationResponse.builder().msg(aBoolean ? "OK" : "TRY AGAIN").result(aBoolean).build())
                )
                .publishOn(Schedulers.boundedElastic())
                .doOnNext(o -> {
                    ReactiveSecurityContextHolder.getContext()
                            .map(securityContext ->
                                    (Long) securityContext.getAuthentication().getDetails())
                            .flatMap(memberId ->
                                    chickRecordService.addChickRecord(filePart, memberId, Long.valueOf(gameNum), sentence))
                            .subscribe();
                });
    }

    @GetMapping("/gameNum")
    public Mono<Long> getGameNum() {
        return gameNumService.getIncrementGameCount();
    }

    //음성 -> 텍스트로바꾸기
    //정답 ("헴 넣어")랑 비교하기
    //"햄,해" 가 있거나, "넣어, 너어, 너, 누어" 가 있으면 통과
    //하나의 조건이라도 만족하지 못하면 틀린 부분을(없는 부분을) 전송
    //예시 -> "햅 넣어 " compare "햄 노아" -> isPass : false, ["넣","어"]

    @GetMapping("/analyzing")
    public Mono<Void> analyzing() {
//        log.info("{}", roomService);
        return Mono.empty();
    }

    @Operation(description = "병아리집 situation 목록 가져오기 & 잠금 여부")
    @GetMapping
    public Mono<List<ChickListResponse>> getChickList() {
        return ReactiveSecurityContextHolder.getContext()
                .map(securityContext ->
                        (Long) securityContext.getAuthentication().getDetails())
                .flatMap(memberId -> chickRecordService.getSituationList(memberId).collectList());
    }

    @Operation(description = "병아리 게임 종료 (1. 다음 병아리 잠금해제, 2. 재화 획득)")
    @PostMapping
    public Mono<ChickEndResponse> endChickGame(@RequestBody ChickEndRequest request) {
        return ReactiveSecurityContextHolder.getContext()
                .map(securityContext ->
                        (Long) securityContext.getAuthentication().getDetails())
                .flatMap(id -> {    // 재화획득 -> 다음 병아리 잠금해제
                    return kidService.addCoin(id, request.getGetCoin())
                            .then(chickRecordService.getNextSituation(id, request.getSituationId()));
//                    return chickService.getNextSituation(id, request.getSituationId());
                })
                .map(result -> {
                    if (result)
                        return new ChickEndResponse(true);
                    else
                        return new ChickEndResponse(false);
                });
        // 열 수 있는 알이 있다면 -> ** 저장 -> 열었다고 응답
    }

    @Operation(description = "병아리 게임 발화 기록 저장")
    @PostMapping("/record")
    public Mono<ChickRecordResponse> setChickRecord(@RequestPart("kidVoice") FilePart filePart,
                                                    @RequestPart("gameNum") String gameNum,
                                                    @RequestPart("sentence") String sentence) {

        // 게임 중간중간에 발음 데이터를 보내서 저장하기 때문에 종료했을 때는 저장할 게 따로 없을 듯
//        // 게임 데이터 저장
//        Mono<Long> memberId = ReactiveSecurityContextHolder.getContext()
//                .map(securityContext ->
//                        (Long) securityContext.getAuthentication().getDetails());
//        // ** 저장 실패할 경우 -> 예외 처리 필요
//        memberId.map(id -> chickService.setChickGameRecord(id, request));
        return null;
    }
}
