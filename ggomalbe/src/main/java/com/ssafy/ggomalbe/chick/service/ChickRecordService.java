package com.ssafy.ggomalbe.chick.service;

import com.ssafy.ggomalbe.chick.dto.ChickListResponse;
import com.ssafy.ggomalbe.common.entity.ChickRecordEntity;
import org.springframework.http.codec.multipart.FilePart;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

public interface ChickRecordService {
    public Mono<ChickRecordEntity> addChickRecord(FilePart filePart, Long memberId, Long gameNum, String sentence);

    Flux<ChickListResponse> getSituationList(Long memberId);

    Mono<Boolean> setChickGameRecord(ChickRecordEntity entity);

    Mono<Boolean> getNextSituation(Long memberId, Long situationId);
}
