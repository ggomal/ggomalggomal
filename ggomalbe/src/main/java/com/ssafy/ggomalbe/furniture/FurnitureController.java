package com.ssafy.ggomalbe.furniture;

import com.ssafy.ggomalbe.furniture.dto.FurnitureListResponse;
import io.swagger.v3.oas.annotations.Operation;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.core.context.ReactiveSecurityContextHolder;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
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

}
