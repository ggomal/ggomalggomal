package com.ssafy.ggomalbe.furniture;

import com.ssafy.ggomalbe.common.repository.FurnitureRepository;
import com.ssafy.ggomalbe.common.repository.MemberRepository;
import com.ssafy.ggomalbe.furniture.dto.FurnitureListResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import reactor.core.publisher.Flux;

@Service
@RequiredArgsConstructor
@Transactional
public class FurnitureServiceImpl implements FurnitureService{

    private final FurnitureRepository furnitureRepository;

    @Override
    public Flux<FurnitureListResponse> getOwnFurniture(Long memberId) {
        return furnitureRepository.getOwnFurnitureList(memberId);
    }
}
