package com.ssafy.ggomalbe.whale;

import com.ssafy.ggomalbe.whale.dto.WhaleEndRequest;
import com.ssafy.ggomalbe.whale.dto.WhaleEvaluationDto;
import org.springframework.http.codec.multipart.FilePart;
import reactor.core.publisher.Mono;

public interface WhaleService {

    Mono<Boolean> setWhaleGameRecord(Long memberId, WhaleEndRequest request);

    Mono<WhaleEvaluationDto> evaluationWhale(FilePart filePart, Long memberId, String sentence);

}
