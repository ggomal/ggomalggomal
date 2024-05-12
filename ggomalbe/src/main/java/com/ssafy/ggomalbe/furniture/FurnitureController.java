package com.ssafy.ggomalbe.furniture;

import com.ssafy.ggomalbe.common.repository.KidRepository;
import com.ssafy.ggomalbe.furniture.dto.FurnitureAddResponse;
import com.ssafy.ggomalbe.furniture.dto.FurnitureAddRequest;
import com.ssafy.ggomalbe.furniture.dto.FurnitureListResponse;
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
@RequiredArgsConstructor
@RequestMapping("/furniture")
public class FurnitureController {

    private final FurnitureService furnitureService;
    private final KidService kidService;

    private final KidRepository kidRepository;

    @Operation(description = "가구 목록 조회 & 보유 여부")
    @GetMapping
    public Mono<List<FurnitureListResponse>> getOwnFurniture(){
        return ReactiveSecurityContextHolder.getContext()
                .map(securityContext ->
                        (Long) securityContext.getAuthentication().getDetails())
                .flatMap(memberId ->
                        furnitureService.getOwnFurniture(memberId).collectList());
    }

    @Operation(description = "가구 구매")
    @PostMapping
    public Mono<FurnitureAddResponse> addFurniture(@RequestBody FurnitureAddRequest request){
        Mono<Long> memberId = ReactiveSecurityContextHolder.getContext()
                .map(securityContext -> (Long) securityContext.getAuthentication().getDetails());

        // 코인 보유량 체크하기
        return memberId.flatMap(kidId ->
                kidRepository.findByMemberId(kidId)
                        .flatMap(kid -> {
                            Long coins = kid.getCoin(); // 사용자의 코인 가져오기
                            if (coins < 2L) {
                                // 코인이 2보다 작은 경우
                                return Mono.just(FurnitureAddResponse.builder()
                                        .furnitureId(request.getFurnitureId())
                                        .isDone(false)
                                        .build());
                            } else {
                                // 코인이 충분한 경우, 가구 추가
                                return kidService.minusCoin(kidId, 2L)
                                        .then(furnitureService.addFurniture(kidId, request)) // 코인 감소 후 가구 추가
                                        .map(furniture -> FurnitureAddResponse.builder()
                                                .furnitureId(furniture.getFurnitureId())
                                                .isDone(true)
                                                .build());
                            }
                        })
        );


        // ** 예외처리 하기
//        memberId.flatMap(kidId -> kidRepository.findById(kidId))
//                .map(kidEntity -> {
//                    Long coin = kidEntity.getCoin();
//                    return kidRepository.setCoin(kidEntity.getMemberId(),coin - 2);
//                });

//        return memberId.flatMap(kidId ->
//                        furnitureService.addFurniture(kidId, request));
    }

}
