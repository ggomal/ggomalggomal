package com.ssafy.ggomalbe.notice;

import com.ssafy.ggomalbe.common.entity.HomeworkEntity;
import com.ssafy.ggomalbe.common.entity.NoticeEntity;
import com.ssafy.ggomalbe.common.repository.HomeworkRepository;
import com.ssafy.ggomalbe.common.repository.NoticeRepository;
import com.ssafy.ggomalbe.homework.HomeworkMapper;
import com.ssafy.ggomalbe.notice.dto.NoticeAddRequest;
import com.ssafy.ggomalbe.notice.dto.NoticeAddResponse;
import com.ssafy.ggomalbe.notice.dto.NoticeResponse;
import com.ssafy.ggomalbe.notice.dto.NoticeUpdateRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;
import reactor.core.scheduler.Schedulers;


@Service
@RequiredArgsConstructor
@Transactional
public class NoticeServiceImpl implements NoticeService {
    private final NoticeRepository noticeRepository;
    private final HomeworkRepository homeworkRepository;

    @Override
    public Flux<NoticeResponse> getAllNotice(Long kidId, Integer month) {
        return noticeRepository.findAllByKidIdAndCreatedAtMonth(kidId, month)
                .map(NoticeMapper::toNoticeResponse)
                .flatMap(notice -> homeworkRepository.findAllByNoticeId(notice.getNoticeId())
                        .map(HomeworkMapper::toHomeworkResponse)
                        .buffer()
                        .map(notice::setHomeworks));
    }

//    @Override
//    public Mono<NoticeResponse> getNotice(Long noticeId) {
//        return noticeRepository.findByNoticeId(noticeId)
//                .map(NoticeMapper::toNoticeResponse);
//    }

    @Override
    public Mono<NoticeAddResponse> addNotice(Long kidId, NoticeAddRequest request) {
        return noticeRepository.save(
                        NoticeEntity.builder()
                                .kidId(kidId)
                                .noticeContents(request.getContents())
                                .teacherName(request.getTeacherName())
                                .build())
                .flatMap(notice ->
                        Mono.just(new NoticeAddResponse(notice, request.getHomeworks())))
                .doOnNext(this::addHomeworks)
                .doOnNext(res -> res.setMsg("SUCCESS"));
    }

    @Override
    public Mono<NoticeResponse> updateNotice(Long kidId, NoticeUpdateRequest request) {
        return noticeRepository.findById(request.getNoticeId())
                // request에 있는대로 notice update
                .doOnNext(notice -> notice.updateContent(request.getContents()))
                .publishOn(Schedulers.boundedElastic())
                // 숙제 있으면 숙제 다 삭제하고 새로 등록
                .doOnNext(notice -> {
                    if (request.getHomeworks() != null) {
                        deleteHomeworks(notice);
                        addHomeworks(notice.getNoticeId(), request.getHomeworks());
                    }
                })
                // 업데이트 된 대로 notice save
                .flatMap(noticeRepository::save)
                .map(NoticeMapper::toNoticeResponse)
                .flatMap(notice -> homeworkRepository.findAllByNoticeId(notice.getNoticeId())
                        .map(HomeworkMapper::toHomeworkResponse)
                        //homework list로 만들어서 담아줍니다.
                        .collectList()
                        .map(notice::setHomeworks));
    }

    private void deleteHomeworks(Long noticeId) {
        homeworkRepository.deleteAllByNoticeId(noticeId).subscribe();
    }

    private void deleteHomeworks(NoticeEntity notice) {
        deleteHomeworks(notice.getNoticeId());
    }

    private void addHomeworks(Long noticeId, String[] homeworks) {
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

    private void addHomeworks(NoticeAddResponse noticeAddResponse) {
        addHomeworks(noticeAddResponse.getNoticeId(), noticeAddResponse.getHomeworks());
    }

}
