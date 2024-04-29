package com.ssafy.ggomalbe.notice;

import com.ssafy.ggomalbe.notice.dto.*;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.*;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

@Slf4j
@RestController
@RequestMapping("/notice")
@RequiredArgsConstructor
public class NoticeController {
    private final NoticeService noticeService;
    @GetMapping()
    public Flux<NoticeListResponse> getAllNotice(){
        // jwt -> kidId
        return noticeService.getAllNotice(3L);
    }

    @GetMapping("/{noticeId}")
    public Mono<NoticeResponse> getNotice(@PathVariable Long noticeId){
        return noticeService.getNotice(noticeId);
    }

    @PostMapping
    public Mono<NoticeAddResponse> addNotice(@RequestBody NoticeAddRequest request){
        // jwt -> kidId
        return noticeService.addNotice(request);
    }

    @PutMapping
    public Mono<NoticeResponse> updateNotice(@RequestBody NoticeUpdateRequest request){
        return noticeService.updateNotice(request);
    }
}
