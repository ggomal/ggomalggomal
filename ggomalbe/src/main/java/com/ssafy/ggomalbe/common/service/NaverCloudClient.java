package com.ssafy.ggomalbe.common.service;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.ssafy.ggomalbe.bear.dto.SttResponse;
import jakarta.annotation.PostConstruct;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Component;
import org.springframework.web.reactive.function.client.WebClient;
import reactor.core.publisher.Mono;

import java.nio.ByteBuffer;
import java.util.Base64;

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
