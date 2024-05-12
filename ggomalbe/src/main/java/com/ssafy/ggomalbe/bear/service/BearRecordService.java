package com.ssafy.ggomalbe.bear.service;

import com.ssafy.ggomalbe.bear.dto.BearRecordResponse;
import com.ssafy.ggomalbe.common.entity.BearRecordEntity;
import org.springframework.http.codec.multipart.FilePart;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

import java.util.Map;

public interface BearRecordService {
    //저장

    //멤버관리번호로 조회
    Flux<BearRecordEntity> getBearRecords(Long memberId);


    //놀이번호로 조회?


    Mono<BearRecordResponse> addBearRecord(FilePart filePart, Long memberId, Long gameNum, Long wordId, String letter, Short pronCount);
    Mono<BearRecordResponse> addBearRecordV2(FilePart filePart, Long memberId, Long gameNum, Long wordId, String letter, Short pronCount);
}
