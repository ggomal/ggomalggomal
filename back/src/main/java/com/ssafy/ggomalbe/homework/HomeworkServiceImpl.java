package com.ssafy.ggomalbe.homework;

import com.ssafy.ggomalbe.common.repository.HomeworkRepository;
import com.ssafy.ggomalbe.homework.dto.HomeworkResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import reactor.core.publisher.Mono;

@Service
@Transactional
@RequiredArgsConstructor
public class HomeworkServiceImpl implements HomeworkService{
    private final HomeworkRepository homeworkRepository;

    @Override
    public Mono<HomeworkResponse> doHomework(Long homeworkId) {
        return homeworkRepository.findById(homeworkId)
                .doOnNext(homeworkEntity -> homeworkEntity.updateDone(true))
                .flatMap(homeworkRepository::save)
                .map(HomeworkMapper::toHomeworkResponse);
    }

    @Override
    public Mono<HomeworkResponse> undoHomework(Long homeworkId) {
        return homeworkRepository.findById(homeworkId)
                .doOnNext(homeworkEntity -> homeworkEntity.updateDone(false))
                .flatMap(homeworkRepository::save)
                .map(HomeworkMapper::toHomeworkResponse);
    }

}
