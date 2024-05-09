package com.ssafy.ggomalbe.whale;

import com.ssafy.ggomalbe.frog.dto.FrogGameEndRequest;
import com.ssafy.ggomalbe.whale.dto.WhaleEndRequest;
import reactor.core.publisher.Mono;

public interface WhaleService {

    Mono<Boolean> setWhaleGameRecord(Long memberId, WhaleEndRequest request);

}
