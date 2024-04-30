package com.ssafy.ggomalbe.notice;

import com.ssafy.ggomalbe.common.entity.HomeworkEntity;
import com.ssafy.ggomalbe.common.entity.NoticeEntity;
import com.ssafy.ggomalbe.common.repository.HomeworkRepository;
import com.ssafy.ggomalbe.common.repository.NoticeRepository;
import com.ssafy.ggomalbe.homework.HomeworkMapper;
import com.ssafy.ggomalbe.homework.dto.HomeworkResponse;
import com.ssafy.ggomalbe.notice.dto.NoticeAddRequest;
import com.ssafy.ggomalbe.notice.dto.NoticeAddResponse;
import com.ssafy.ggomalbe.notice.dto.NoticeResponse;
import com.ssafy.ggomalbe.notice.dto.NoticeUpdateRequest;
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
    public Flux<NoticeResponse> getAllNotice(Long kidId) {
        return noticeRepository.findAllByKidId(kidId)
                .map(NoticeMapper::toNoticeResponse)
                .flatMap(notice -> homeworkRepository.findAllByNoticeId(notice.getNoticeId())
                        .map(HomeworkMapper::toHomeworkResponse)
                        .buffer()
                        .map(notice::setHomeworks));
    }

    @Override
    public Mono<NoticeResponse> getNotice(Long noticeId) {
        return noticeRepository.findByNoticeId(noticeId)
                .map(NoticeMapper::toNoticeResponse);
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
                        Mono.just(new NoticeAddResponse(notice, request.getHomeworks())))
                .doOnNext(this::addHomeworks);
    }

    @Override
    public Mono<NoticeResponse> updateNotice(NoticeUpdateRequest request) {
        return noticeRepository.findById(request.getNoticeId())
                .doOnNext(notice -> notice.update(request))
                .doOnNext(this::deleteHomeworks)
                .doOnNext(entity -> addHomeworks(entity.getNoticeId(), request.getHomeworks()))
                .flatMap(noticeRepository::save)
                .map(NoticeMapper::toNoticeResponse)
                .flatMap(notice -> homeworkRepository.findAllByNoticeId(notice.getNoticeId())
                        .map(HomeworkMapper::toHomeworkResponse)
                        .collectList()
                        .map(notice::setHomeworks));
    }

    public void findHomeworkResponse(NoticeResponse noticeResponse) {
        homeworkRepository.findAllByNoticeId(noticeResponse.getNoticeId())
                .map(HomeworkMapper::toHomeworkResponse)
                .doOnNext(response -> noticeResponse.getHomeworks().add(response))
                .doOnNext(System.out::println)
                .subscribe();
    }

    public void deleteHomeworks(Long noticeId) {
        homeworkRepository.deleteAllByNoticeId(noticeId).subscribe();
    }

    public void deleteHomeworks(NoticeEntity notice) {
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
