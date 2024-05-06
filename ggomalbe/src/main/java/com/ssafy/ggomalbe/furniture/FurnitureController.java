package com.ssafy.ggomalbe.furniture;

import com.ssafy.ggomalbe.common.repository.KidRepository;
import com.ssafy.ggomalbe.furniture.dto.FurnitureAddResponse;
import com.ssafy.ggomalbe.furniture.dto.FurnitureAddRequest;
import com.ssafy.ggomalbe.furniture.dto.FurnitureListResponse;
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

    @Operation(description = "보유 가구 조회")
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
                .map(securityContext ->
                        (Long) securityContext.getAuthentication().getDetails());

        // ** 코인 보유량 체크하기
        // ** 예외처리 하기
//        memberId.flatMap(kidId -> kidRepository.findById(kidId))
//                .map(kidEntity -> {
//                    Long coin = kidEntity.getCoin();
//                    return kidRepository.setCoin(kidEntity.getMemberId(),coin - 2);
//                });

        return memberId.flatMap(kidId ->
                        furnitureService.addFurniture(kidId, request));
    }

}
