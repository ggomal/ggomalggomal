package com.ssafy.ggomalbe.bear.service;

import org.springframework.http.codec.multipart.FilePart;
import reactor.core.publisher.Mono;

import java.util.Map;

public interface BearRecordService {
    //저장

    //멤버관리번호로 조회



    //놀이번호로 조회?



    /**
     * 평가데이터 저장
     * @param letter : 말해야 하는 정답 단어
     * @param filePart : 아이가 단어를 읽고 녹음한 데이터
     * @return
     * score: letter와 아이의 음성을 비교하여 도출한 점수
     * stt: 아이의 음성을 텍스트로 변환한 문자열
     * letter : 아이가 말해야하는 정답 단어
     */
    Mono<Map<String, String>> evaluate(FilePart filePart, String letter);
}
