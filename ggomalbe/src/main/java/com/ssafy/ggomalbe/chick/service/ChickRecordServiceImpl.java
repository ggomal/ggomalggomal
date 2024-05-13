package com.ssafy.ggomalbe.chick.service;

import com.ssafy.ggomalbe.chick.dto.ChickEvaluationResponse;
import com.ssafy.ggomalbe.chick.dto.ChickListResponse;
import com.ssafy.ggomalbe.common.dto.superspeech.PronunciationResDto;
import com.ssafy.ggomalbe.common.dto.superspeech.WordResDto;
import com.ssafy.ggomalbe.common.entity.SituationKidEntity;
import com.ssafy.ggomalbe.common.repository.ChickRecognitionRepository;
import com.ssafy.ggomalbe.common.repository.SituationKidRepository;
import com.ssafy.ggomalbe.common.repository.SituationRepository;
import com.ssafy.ggomalbe.common.service.EvaluationService;
import com.ssafy.ggomalbe.common.service.NaverCloudClient;
import com.ssafy.ggomalbe.common.service.OpenApiClient;
import com.ssafy.ggomalbe.common.entity.ChickRecordEntity;
import com.ssafy.ggomalbe.common.repository.ChickRecordRepository;
import com.ssafy.ggomalbe.common.service.SpeechSuperService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.codec.multipart.FilePart;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@Transactional
@RequiredArgsConstructor
@Slf4j
public class ChickRecordServiceImpl implements ChickRecordService{
    private final ChickRecordRepository chickRecordRepository;
    private final EvaluationService evaluationService;
    private final SituationRepository situationRepository;
    private final SituationKidRepository situationKidRepository;
    private final ChickRecognitionRepository chickRecognitionRepository;
    private final SpeechSuperService speechSuperService;

    @Override
    public Mono<Boolean> checkSentence(FilePart filePart, String sentence) {
        return evaluationService.toText(filePart)
                .flatMap(stt -> {
                    log.info(stt);
                    return chickRecognitionRepository.existsByOriginTextAndRecognitionScope(sentence, stt);
                });
    }

    @Override
    public Mono<ChickEvaluationResponse> addChickRecord(FilePart filePart, Long memberId, Long gameNum, String sentence) {
        return speechSuperService.evaluation(filePart,sentence)
                .map(PronunciationResDto::getResult)
                .map(result -> {
                    Boolean overResult = true;
                    List<Boolean> words = new ArrayList<>();
                    for (WordResDto wrd : result.getWords()){
                        words.add(wrd.getScores().getPronunciation() >= 70);
                        overResult &= words.get(words.size()-1);
                    }
                    log.info("chick_record result : " + words.toString());
                    return ChickEvaluationResponse.builder()
                            .refWord(sentence)
                            .overResult(overResult)
                            .words(words)
                            .build();
                });
    }

    @Override
    public Flux<ChickListResponse> getSituationList(Long memberId) {
        return situationRepository.getOwnSituationList(memberId);
    }

    @Override
    public Mono<Boolean> getNextSituation(Long memberId, Long situationId) {
        return situationRepository.count()
                .flatMap(max -> {
                    // ** 마지막 병아리가 아닌데 이미 잠금 해제 했을 경우 -> 다음 거 이미 열려있는 경우 그냥 처리 안하고 넘겨 줘야함
                    if (situationId >= max) {   // 마지막 병아리일 경우
                        return Mono.just(false);
                    } else {
                        SituationKidEntity entity = SituationKidEntity.builder()
                                .situationId(situationId+1)
                                .memberId(memberId)
                                .build();

                        return situationKidRepository.existsByMemberIdAndSituationId(memberId, situationId + 1)
                                .flatMap(flag -> {
                                    if (!flag)
                                        return situationKidRepository.save(entity)
                                                .map(result -> result.getSituationKidId() != null);
                                    else
                                        return Mono.just(false);
                                });
                    }
                });
    }


    @Override
    public Mono<Boolean> setChickGameRecord(ChickRecordEntity entity) {
        return chickRecordRepository.save(entity)
                .map(saveEntity -> saveEntity.getChickRecordId() != null);
    }


//    public Mono<Void> isPass(FilePart filePart, String sentence) {
//        return filePart
//                .content()
//                .flatMapSequential(dataBuffer -> Flux.fromIterable(dataBuffer::readableByteBuffers))
//                .reduce((b1, b2) -> {
//                    b1.put(b2);
//                    return b1;
//                })
//                .flatMap(buffer -> naverCloudClient.soundToText(buffer))
//                .doOnNext(n->log.info("{}",n)).then();
//    }
}
