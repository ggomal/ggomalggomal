package com.ssafy.ggomalbe.notice;

import com.ssafy.ggomalbe.common.entity.MemberEntity;
import com.ssafy.ggomalbe.notice.dto.*;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.MediaType;
import org.springframework.security.core.context.ReactiveSecurityContextHolder;
import org.springframework.web.bind.annotation.*;
import reactor.core.publisher.Mono;

import java.awt.*;
import java.util.List;

@Slf4j
@RestController
@RequestMapping("/notice")
@RequiredArgsConstructor
public class NoticeController {
    private final NoticeService noticeService;

    @GetMapping("/{month}")
    public Mono<List<NoticeResponse>> getAllNotice(@PathVariable Integer month) {
        return ReactiveSecurityContextHolder.getContext()
                .map(securityContext ->
                        (Long) securityContext.getAuthentication().getDetails())
                .flatMap( memberId -> noticeService.getAllNotice(memberId, month)
                        .collectList());
    }

    @PostMapping
    public Mono<NoticeAddResponse> addNotice(@RequestBody NoticeAddRequest request) {
        return ReactiveSecurityContextHolder.getContext()
                .map(securityContext ->{
                    request.setTeacherName(securityContext.getAuthentication().getName());
                        return (Long) securityContext.getAuthentication().getDetails();})
                .flatMap(kidId ->
                        noticeService.addNotice(kidId, request));
    }

    @PutMapping
    public Mono<NoticeResponse> updateNotice(@RequestBody NoticeUpdateRequest request) {
        return ReactiveSecurityContextHolder.getContext()
                .map(securityContext ->
                        (Long) securityContext.getAuthentication().getDetails())
                .flatMap(kidId ->
                        noticeService.updateNotice(kidId, request));
    }
}
