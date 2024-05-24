package com.ssafy.ggomalbe.notice;

import com.ssafy.ggomalbe.notice.dto.*;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

import java.time.LocalDate;

public interface NoticeService {
    Flux<NoticeResponse> getAllNotice(Long kidId, Integer month);
    Mono<NoticeResponse> getNotice(Long kidId, LocalDate date);
    Mono<NoticeAddResponse> addNotice(Long memberId, NoticeAddRequest request);
    Mono<NoticeResponse> updateNotice(Long kidId, NoticeUpdateRequest request);
}
