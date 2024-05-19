//package com.ssafy.ggomalbe.chick.service;
//
//import com.ssafy.ggomalbe.chick.dto.ChickListResponse;
//import com.ssafy.ggomalbe.chick.dto.ChickRecordRequest;
//import com.ssafy.ggomalbe.common.entity.ChickRecordEntity;
//import reactor.core.publisher.Flux;
//import reactor.core.publisher.Mono;
//
//public interface ChickService {
//
//    Flux<ChickListResponse> getSituationList(Long memberId);
//
//    Mono<Boolean> setChickGameRecord(ChickRecordEntity entity);
//
//    Mono<Boolean> getNextSituation(Long memberId, Long situationId);
//
//}
