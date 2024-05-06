package com.ssafy.ggomalbe.chick;

import com.ssafy.ggomalbe.chick.dto.*;
import com.ssafy.ggomalbe.member.kid.KidService;
import io.swagger.v3.oas.annotations.Operation;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.core.context.ReactiveSecurityContextHolder;
import org.springframework.web.bind.annotation.*;
import reactor.core.publisher.Mono;

import java.util.List;

@Slf4j
@RestController
@RequestMapping("/chick")
@RequiredArgsConstructor
public class ChickController {

    private final KidService kidService;
    private final ChickService chickService;

    @Operation(description = "병아리집 situation 목록 가져오기 & 잠금 여부")
    @GetMapping
    public Mono<List<ChickListResponse>> getChickList(){
        return ReactiveSecurityContextHolder.getContext()
                .map(securityContext ->
                        (Long) securityContext.getAuthentication().getDetails())
                .flatMap(memberId -> chickService.getSituationList(memberId).collectList());
    }

    @Operation(description = "병아리 게임 종료 (1. 다음 병아리 잠금해제, 2. 재화 획득)")
    @PostMapping
    public Mono<ChickEndResponse> endChickGame(@RequestBody ChickEndRequest request){
        return ReactiveSecurityContextHolder.getContext()
                .map(securityContext ->
                        (Long) securityContext.getAuthentication().getDetails())
                .flatMap(id -> {
                    kidService.addCoin(id, request.getGetCoin());   // 2. 재화획득
                    return chickService.getNextSituation(id, request.getSituationId()); // 1. 다음 병아리 잠금해제
                })
                .map(result -> {
                    if (result)
                        return new ChickEndResponse("새로운 병아리를 획득했어요!");
                    else
                        return new ChickEndResponse("업데이트를 기다려주세요:)");
                });
        // 열 수 있는 알이 있다면 -> ** 저장 -> 열었다고 응답
    }

    @Operation(description = "병아리 게임 발화 기록 저장")
    @PostMapping("/record")
    public Mono<ChickRecordResponse> setChickRecord(@RequestBody ChickRecordRequest request) {

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
