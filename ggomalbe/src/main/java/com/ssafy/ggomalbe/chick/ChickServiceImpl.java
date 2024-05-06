package com.ssafy.ggomalbe.chick;

import com.ssafy.ggomalbe.chick.dto.ChickListResponse;
import com.ssafy.ggomalbe.chick.dto.ChickRecordRequest;
import com.ssafy.ggomalbe.common.entity.ChickRecordEntity;
import com.ssafy.ggomalbe.common.entity.SituationKidEntity;
import com.ssafy.ggomalbe.common.repository.ChickRecordRepository;
import com.ssafy.ggomalbe.common.repository.SituationKidRepository;
import com.ssafy.ggomalbe.common.repository.SituationRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

@Service
@Slf4j
@RequiredArgsConstructor
@Transactional
public class ChickServiceImpl implements ChickService{

    private final SituationRepository situationRepository;
    private final SituationKidRepository situationKidRepository;

    private final ChickRecordRepository chickRecordRepository;

    @Override
    public Flux<ChickListResponse> getSituationList(Long memberId) {
        return situationRepository.getOwnSituationList(memberId);
    }

    @Override
    public Mono<Boolean> getNextSituation(Long memberId, Long situationId) {
            return situationRepository.count()
                    .flatMap(max -> {
                        // ** 마지막 병아리가 아닌데 이미 잠금 해제 했을 경우 -> 다음 거 이미 열려있는 경우 그냥 처리 안하고 넘겨 줘야함
                        if (situationId >= max) {   // 마지막 병아리일 경우
                            return Mono.just(false);
                        } else {
                            SituationKidEntity entity = SituationKidEntity.builder()
                                    .situationId(situationId+1)
                                    .memberId(memberId)
                                    .build();
                            return situationKidRepository.save(entity)
                                    .map(result -> result.getSituationKidId() != null);
                        }
                    });
    }


    @Override
    public Mono<Boolean> setChickGameRecord(Long memberId, ChickRecordRequest request) {
        // ** 구현해야 함
        ChickRecordEntity entity = ChickRecordEntity.builder()
//                .memberId(memberId)
//                .durationSec(request.getDurationSec())
//                .length(request.getLength())
                .build();

        return chickRecordRepository.save(entity)
                .map(saveEntity -> saveEntity.getChickRecordId() != null ? true : false);
    }
}
