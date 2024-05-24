package com.ssafy.ggomalbe.furniture;

import com.ssafy.ggomalbe.common.entity.KidFurnitureEntity;
import com.ssafy.ggomalbe.furniture.dto.FurnitureAddRequest;
import com.ssafy.ggomalbe.furniture.dto.FurnitureAddResponse;
import com.ssafy.ggomalbe.furniture.dto.FurnitureListResponse;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

public interface FurnitureService {
    Flux<FurnitureListResponse> getOwnFurniture(Long memberId);

    Mono<FurnitureAddResponse> addFurniture(Long memberId, FurnitureAddRequest request);
}
