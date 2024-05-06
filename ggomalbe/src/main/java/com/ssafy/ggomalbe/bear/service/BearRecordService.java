package com.ssafy.ggomalbe.bear.service;

import com.ssafy.ggomalbe.common.entity.BearRecordEntity;
import org.springframework.http.codec.multipart.FilePart;
import reactor.core.publisher.Mono;

import java.util.Map;

public interface BearRecordService {
    //저장

    //멤버관리번호로 조회



    //놀이번호로 조회?


    Mono<BearRecordEntity> addBearRecord(FilePart filePart, Long memberId, Long gameNum, Long wordId, String letter, Short pronCount);
}
