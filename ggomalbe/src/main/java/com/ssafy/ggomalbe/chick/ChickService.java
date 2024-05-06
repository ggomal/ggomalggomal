package com.ssafy.ggomalbe.chick;

import com.ssafy.ggomalbe.chick.dto.ChickListResponse;
import com.ssafy.ggomalbe.chick.dto.ChickRecordRequest;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

public interface ChickService {

    Flux<ChickListResponse> getSituationList(Long memberId);

    Mono<Boolean> setChickGameRecord(Long memberId, ChickRecordRequest request);

    Mono<Boolean> getNextSituation(Long memberId, Long situationId);

}
