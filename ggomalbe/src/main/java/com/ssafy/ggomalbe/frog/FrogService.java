package com.ssafy.ggomalbe.frog;

import com.ssafy.ggomalbe.common.entity.FrogRecordEntity;
import com.ssafy.ggomalbe.frog.dto.FrogGameEndRequest;
import reactor.core.publisher.Mono;

public interface FrogService {

    public Mono<Boolean> setGameRecord(Long memberId, FrogGameEndRequest request);
}
