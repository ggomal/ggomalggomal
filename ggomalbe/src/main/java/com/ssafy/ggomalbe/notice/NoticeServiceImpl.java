package com.ssafy.ggomalbe.notice;

import com.ssafy.ggomalbe.common.entity.HomeworkEntity;
import com.ssafy.ggomalbe.common.entity.NoticeEntity;
import com.ssafy.ggomalbe.common.repository.HomeworkRepository;
import com.ssafy.ggomalbe.common.repository.NoticeRepository;
import com.ssafy.ggomalbe.homework.dto.HomeworkResponse;
import com.ssafy.ggomalbe.notice.dto.*;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;
import reactor.core.scheduler.Schedulers;


@Service
@RequiredArgsConstructor
public class NoticeServiceImpl implements NoticeService {
    private final NoticeRepository noticeRepository;
    private final HomeworkRepository homeworkRepository;

    @Override
    public Flux<NoticeListResponse> getAllNotice(Long kidId) {
        return noticeRepository.findByKidId(kidId)
                .map(notice ->
                        NoticeListResponse.builder()
                                .noticeId(notice.getNoticeId())
                                .date(notice.getCreatedAt())
                                .build());
    }

    @Override
    public Mono<NoticeResponse> getNotice(Long noticeId) {
        return noticeRepository.findByNoticeId(noticeId);
    }

    @Override
    public Mono<NoticeAddResponse> addNotice(NoticeAddRequest request) {
        return noticeRepository.save(
                        NoticeEntity.builder()
                                .kidId(request.getKidId())
                                .noticeContents(request.getContents())
                                .teacherName(request.getTeacherName())
                                .build())
                .flatMap(notice ->
                        Mono.just(new NoticeAddResponse(notice, request.getHomework())))
                .doOnNext(this::addHomeworks);
    }

    @Override
    public Mono<NoticeResponse> updateNotice(NoticeUpdateRequest request) {
        return noticeRepository.findById(request.getNoticeId())
                .doOnNext(notice -> notice.update(request))
                .doOnNext(this::deleteHomeworks)
                .doOnNext(entity -> addHomeworks(entity.getNoticeId(), request.getHomework()))
                .flatMap(noticeRepository::save)
                .doOnNext(System.out::println)
                .flatMap(entity -> noticeRepository.findByNoticeId(entity.getNoticeId()));
    }


    public void deleteHomeworks(Long noticeId) {
        homeworkRepository.deleteAllByNoticeId(noticeId).subscribe();
    }
    public void deleteHomeworks(NoticeEntity notice){
        deleteHomeworks(notice.getNoticeId());
    }

    public void addHomeworks(Long noticeId, String[] homeworks) {
        Flux.fromArray(homeworks)
                .publishOn(Schedulers.boundedElastic())
                .doOnNext(hwString ->
                        homeworkRepository.save(
                                HomeworkEntity.builder()
                                        .noticeId(noticeId)
                                        .homeworkContents(hwString)
                                        .build()).subscribe())
                .subscribe();
    }

    public void addHomeworks(NoticeAddResponse noticeAddResponse) {
        addHomeworks(noticeAddResponse.getNoticeId(), noticeAddResponse.getHomeworks());
    }

}
