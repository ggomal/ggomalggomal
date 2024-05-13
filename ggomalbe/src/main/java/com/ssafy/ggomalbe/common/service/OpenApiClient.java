package com.ssafy.ggomalbe.common.service;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.ssafy.ggomalbe.bear.dto.OpenApiResponse;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Component;
import org.springframework.web.reactive.function.BodyInserters;
import org.springframework.web.reactive.function.client.WebClient;
import reactor.core.publisher.Mono;

import java.nio.ByteBuffer;
import java.time.Duration;
import java.util.Base64;
import java.util.HashMap;
import java.util.Map;
import java.util.function.Consumer;

@Component
@Slf4j
public class OpenApiClient {
    private final ObjectMapper objectMapper;

    private final WebClient webClient;

    @Value("${openapi.accessKey}")
    String accessKey;

    public OpenApiClient(ObjectMapper objectMapper) {
        this.objectMapper = objectMapper;
        this.webClient = WebClient.builder()
                .baseUrl("http://aiopen.etri.re.kr:8000/WiseASR/PronunciationKor")
                .build();
    }

    public Mono<OpenApiResponse> letterToScore(String originText, ByteBuffer file) {
//        String openApiURL = "http://aiopen.etri.re.kr:8000/WiseASR/Pronunciation"; // 영어
        String openApiURL = "http://aiopen.etri.re.kr:8000/WiseASR/PronunciationKor";   //한국어

        String languageCode = "korean";     // 언어 코드
        String script = originText;    // 평가 대본
        WebClient webClient = WebClient.builder().build();

        Map<String, Object> request = new HashMap<>();
        Map<String, String> argument = new HashMap<>();


        return Mono.fromCallable(() -> file)
                .flatMap(dataBuffer -> {
                    // ByteBuffer의 위치(position)를 0으로 설정
                    dataBuffer.rewind();

                    byte[] byteArray = new byte[dataBuffer.remaining()]; // 남은 데이터 양으로 바이트 배열 생성
                    dataBuffer.get(byteArray); // ByteBuffer의 데이터를 바이트 배열에 복사

                    String audioContents = Base64.getEncoder().encodeToString(byteArray);

                    log.info("말해야하는 문장 [{}]", script);
//                    log.info("audioContents {}", audioContents);

                    argument.put("language_code", languageCode);
                    argument.put("script", script);
                    argument.put("audio", audioContents);

                    request.put("argument", argument);

                    return webClient.post()
                            .uri(openApiURL)
                            .header(HttpHeaders.CONTENT_TYPE, MediaType.APPLICATION_JSON_VALUE)
                            .header(HttpHeaders.AUTHORIZATION, accessKey)
                            .body(BodyInserters.fromValue(request))
                            .retrieve()
                            .bodyToMono(OpenApiResponse.class)
                            .timeout(Duration.ofSeconds(5))
                            .onErrorReturn(new OpenApiResponse(0,null, new HashMap<String, String>() {{
                                put("recognized", script);
                                put("score", "0");
                            }}));
                });
    }
}
