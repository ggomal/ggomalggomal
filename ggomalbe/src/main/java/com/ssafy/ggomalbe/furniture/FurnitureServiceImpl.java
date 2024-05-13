package com.ssafy.ggomalbe.furniture;

import com.ssafy.ggomalbe.common.entity.KidFurnitureEntity;
import com.ssafy.ggomalbe.common.entity.NoticeEntity;
import com.ssafy.ggomalbe.common.repository.FurnitureRepository;
import com.ssafy.ggomalbe.common.repository.KidFurnitureRepository;
import com.ssafy.ggomalbe.furniture.dto.FurnitureAddRequest;
import com.ssafy.ggomalbe.furniture.dto.FurnitureAddResponse;
import com.ssafy.ggomalbe.furniture.dto.FurnitureListResponse;
import com.ssafy.ggomalbe.notice.dto.NoticeAddResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

@Service
@RequiredArgsConstructor
@Transactional
public class FurnitureServiceImpl implements FurnitureService{

    private final FurnitureRepository furnitureRepository;
    private final KidFurnitureRepository kidFurnitureRepository;

    @Override
    public Flux<FurnitureListResponse> getOwnFurniture(Long memberId) {
        return furnitureRepository.getOwnFurnitureList(memberId);
    }

    @Override
    public Mono<FurnitureAddResponse> addFurniture(Long memberId, FurnitureAddRequest request) {
        Long furnitureId = request.getFurnitureId();

        return kidFurnitureRepository.existsByMemberIdAndFurnitureId(memberId, furnitureId)
                .flatMap(exists -> {
                    if (exists) {
                        return Mono.just(FurnitureAddResponse.builder()
                                .furnitureId(request.getFurnitureId())
                                .isDone(false)
                                .build());
                    } else {
                        // 가구 구매 로직 수행
                        return kidFurnitureRepository.save(
                                        KidFurnitureEntity.builder()
                                                .memberId(memberId)
                                                .furnitureId(furnitureId)
                                                .build())
                                .flatMap(entity ->
                                        furnitureRepository.findById(entity.getFurnitureId()))
                                .map(entity ->
                                        new FurnitureAddResponse(entity.getFurnitureId()));
                    }
                });
    }

}
