package com.ssafy.ggomalbe.whale;

import com.ssafy.ggomalbe.common.dto.superspeech.WordResDto;
import com.ssafy.ggomalbe.common.entity.ChickRecordEntity;
import com.ssafy.ggomalbe.common.entity.WhaleRecordEntity;
import com.ssafy.ggomalbe.common.repository.WhaleRecordRepository;
import com.ssafy.ggomalbe.common.service.SpeechSuperService;
import com.ssafy.ggomalbe.whale.dto.WhaleEndRequest;
import com.ssafy.ggomalbe.whale.dto.WhaleEvaluationDto;
import com.ssafy.ggomalbe.whale.dto.WordScore;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.codec.multipart.FilePart;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import reactor.core.publisher.Mono;

import java.util.ArrayList;
import java.util.List;

@Service
@Slf4j
@RequiredArgsConstructor
@Transactional
public class WhaleServiceImpl implements WhaleService {

    private final WhaleRecordRepository whaleRecordRepository;
    private final SpeechSuperService speechSuperService;

    @Override
    public Mono<Boolean> setWhaleGameRecord(Long memberId, WhaleEndRequest request) {

        WhaleRecordEntity entity = WhaleRecordEntity.builder()
                .memberId(memberId)
                .maxTime(request.getMaxTime())
                .build();

        return whaleRecordRepository.save(entity)
                .map(saveEntity -> saveEntity.getWhaleRecordId() != null);
    }


    @Override
    public Mono<WhaleEvaluationDto> evaluationWhale(FilePart filePart, Long memberId, String sentence) {
        return speechSuperService.evaluation(filePart,sentence)
                .map(result -> result.getResult())
                .map(result -> {
                    boolean overResult = true;
                    List<Boolean> wordResult = new ArrayList<>();

                    List<WordScore> wordScores = new ArrayList<>();

                    for (WordResDto wrd : result.getWords()){
                        boolean flag = wrd.getScores().getPronunciation() >= 70;
                        wordResult.add(flag);
                        overResult &= flag;

                        wordScores.add(new WordScore(wrd.getWord(),wrd.getScores().getPronunciation()));
                    }

                    float score = result.getPronunciation();
                    log.info("whale_record result : {}" , wordResult.toString());
                    return WhaleEvaluationDto.builder()
                            .refSentence(sentence)
                            .allResult(overResult)
                            .wordResult(wordResult)
                            .wordScores(wordScores)
                            .memberId(memberId)
                            .score(score)
                            .build();
                });
    }

//    @Override
//    public Mono<Boolean> addWhaleRecord(WhaleRecordEntity entity) {
//        return whaleRecordRepository.save(entity)
//                .map(saveEntity -> saveEntity.getChickRecordId() != null);
//    }

}
