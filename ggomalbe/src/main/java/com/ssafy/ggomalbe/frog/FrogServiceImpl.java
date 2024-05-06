package com.ssafy.ggomalbe.frog;

import com.ssafy.ggomalbe.common.entity.FrogRecordEntity;
import com.ssafy.ggomalbe.common.repository.FrogRecordRepository;
import com.ssafy.ggomalbe.frog.dto.FrogGameEndRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import reactor.core.publisher.Mono;

@Service
@RequiredArgsConstructor
@Transactional
public class FrogServiceImpl implements FrogService {

    private final FrogRecordRepository frogRecordRepository;

    public Mono<Boolean> setGameRecord(Long memberId, FrogGameEndRequest request){
        FrogRecordEntity entity = FrogRecordEntity.builder()
                .memberId(memberId)
                .playTime(request.getPlayTime())
                .durationSec(request.getDurationSec())
                .length(request.getLength())
                .build();

        return frogRecordRepository.save(entity)
                .map(saveEntity -> saveEntity.getFrogRecordId() != null ? true : false);
    }
}
