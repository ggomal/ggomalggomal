package com.ssafy.ggomalbe.furniture;

import com.ssafy.ggomalbe.furniture.dto.FurnitureListResponse;
import reactor.core.publisher.Flux;

public interface FurnitureService {
    Flux<FurnitureListResponse> getOwnFurniture(Long memberId);
}
