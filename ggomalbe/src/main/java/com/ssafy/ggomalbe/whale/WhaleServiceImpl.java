package com.ssafy.ggomalbe.whale;

import com.ssafy.ggomalbe.common.entity.FrogRecordEntity;
import com.ssafy.ggomalbe.common.entity.WhaleRecordEntity;
import com.ssafy.ggomalbe.common.repository.WhaleRecordRepository;
import com.ssafy.ggomalbe.whale.dto.WhaleEndRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import reactor.core.publisher.Mono;

@Service
@RequiredArgsConstructor
@Transactional
public class WhaleServiceImpl implements WhaleService {

    private final WhaleRecordRepository whaleRecordRepository;

    @Override
    public Mono<Boolean> setWhaleGameRecord(Long memberId, WhaleEndRequest request) {

        WhaleRecordEntity entity = WhaleRecordEntity.builder()
                .memberId(memberId)
                .maxTime(request.getMaxTime())
                .build();

        return whaleRecordRepository.save(entity)
                .map(saveEntity -> saveEntity.getWhaleRecordId() != null);
    }
}
