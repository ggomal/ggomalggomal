package com.ssafy.ggomalbe.common.service;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.ssafy.ggomalbe.bear.dto.LetterSoundRequest;
import com.ssafy.ggomalbe.bear.dto.SttResponse;
import com.ssafy.ggomalbe.bear.service.WordService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Component;
import org.springframework.web.reactive.function.client.WebClient;
import reactor.core.publisher.Mono;

import java.nio.ByteBuffer;
import java.util.ArrayList;
import java.util.List;

@Component
@Slf4j
public class NaverCloudClient {

    private final ObjectMapper objectMapper;

    @Value("${naver.cloud.id}")
    String CLIENT_ID;

    @Value("${naver.cloud.secrete}")
    String CLIENT_SECRET;

    private final WebClient webClient;

    public NaverCloudClient(ObjectMapper objectMapper) {
        this.objectMapper = objectMapper;
        this.webClient = WebClient.builder()
                .baseUrl("https://naveropenapi.apigw.ntruss.com")
                .build();
    }

    // 순서
    // 1. 저장한 단어 -> CLOVA API로 전송
    // 2. 음성파일 리턴 -> S3 /sound 폴더에 저장
    // 3. 저장된 url 반환해서 DB update
    public List<LetterSoundRequest> getWordSound(List<String> wordList){
        List<LetterSoundRequest> result = new ArrayList<>();

        try {
            // 저장한 단어 -> 클로바 api로 전송
            for (String word : wordList){
                // 음성파일을 리턴 받아서 s3 /sound 폴더에 저장
                byte[] audioData = webClient.post()
                        .uri(uriBuilder -> uriBuilder.path("/tts-premium/v1/tts")
                                .queryParam("speaker", "ndain")
                                .queryParam("text", word)
                                .queryParam("format", "mp3")
                                .build())
                        .header("X-NCP-APIGW-API-KEY-ID", CLIENT_ID)
                        .header("X-NCP-APIGW-API-KEY", CLIENT_SECRET)
                        .contentType(MediaType.APPLICATION_FORM_URLENCODED)
                        .retrieve()
                        .bodyToMono(byte[].class)
                        .block();

                if (audioData != null) {
                    // S3에 저장하거나 다른 작업을 수행할 수 있음
//                    uploadMP3ToS3(audioData);
                }


                // 저장된 s3 url 리스트 반환
//                result.add()
            }

        } catch (Error e) {
            e.printStackTrace();
        }

        return result;
    }

    public Mono<String> soundToText(ByteBuffer file) {
        return Mono.fromCallable(() -> file)
                .flatMap(fileContent -> {
                    String language = "Kor";
                    return webClient.post()
                            .uri(uriBuilder -> uriBuilder.path("/recog/v1/stt")
                                    .queryParam("lang", language)
                                    .build())
                            .header("X-NCP-APIGW-API-KEY-ID", CLIENT_ID)
                            .header("X-NCP-APIGW-API-KEY", CLIENT_SECRET)
                            .contentType(MediaType.APPLICATION_OCTET_STREAM)
                            .bodyValue(fileContent)
                            .retrieve()
                            .bodyToMono(String.class)
                            .map(this::getTextFromResponse);
                });
    }

//    public Mono<String> soundToTextSocket(String audioData ) {
//        byte[] decodedBytes = Base64.getDecoder().decode(audioData);
//        return Mono.fromCallable(() -> decodedBytes)
//                .flatMap(fileContent -> {
//                    String language = "Kor";
//                    return webClient.post()
//                            .uri(uriBuilder -> uriBuilder.path("/recog/v1/stt")
//                                    .queryParam("lang", language)
//                                    .build())
//                            .header("X-NCP-APIGW-API-KEY-ID", CLIENT_ID)
//                            .header("X-NCP-APIGW-API-KEY", CLIENT_SECRET)
//                            .contentType(MediaType.APPLICATION_OCTET_STREAM)
//                            .bodyValue(fileContent)
//                            .retrieve()
//                            .bodyToMono(String.class)
//                            .map(this::getTextFromResponse);
//                });
//    }

    private String getTextFromResponse(String responseStr) {
        try {
            return objectMapper.readValue(responseStr, SttResponse.class).getText();
        } catch (JsonProcessingException e) {
            throw new RuntimeException(e);
        }
    }
}
