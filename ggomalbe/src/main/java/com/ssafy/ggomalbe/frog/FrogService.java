package com.ssafy.ggomalbe.frog;

import com.ssafy.ggomalbe.frog.dto.FrogGameEndRequest;
import reactor.core.publisher.Mono;

public interface FrogService {

    Mono<Boolean> setFrogGameRecord(Long memberId, FrogGameEndRequest request);
}
