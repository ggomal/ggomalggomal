package com.ssafy.ggomalbe.notice;

import com.ssafy.ggomalbe.notice.dto.*;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

public interface NoticeService {
    Flux<NoticeResponse> getAllNotice(Long kidId);
    Mono<NoticeResponse> getNotice(Long noticeId);
    Mono<NoticeAddResponse> addNotice(NoticeAddRequest request);
    Mono<NoticeResponse> updateNotice(NoticeUpdateRequest request);
}
