package com.ssafy.ggomalbe.common.service;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.ssafy.ggomalbe.bear.dto.LetterSoundRequest;
import com.ssafy.ggomalbe.bear.dto.SttResponse;
import com.ssafy.ggomalbe.common.dto.UploadResult;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Component;
import org.springframework.web.reactive.function.client.WebClient;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.nio.ByteBuffer;
import java.nio.file.Path;
import java.nio.file.Paths;
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
    public Mono<Void> getWordSound(String word){
        String awsS3Path = "https://ggomalggomal.s3.ap-southeast-2.amazonaws.com/ggomal/sound/";
        // + "fileName/word.mp3"
        // URLEncoder.encode(word, "UTF-8");

        try {
            System.out.println("NaverCloudClient - getWordSound");
            // 단어 -> 클로바 api로 전송
            // ** 여기서 안넘어감
            return webClient.post()
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
                    .flatMap(this::writeToFile);

//            try (FileOutputStream stream = new FileOutputStream("/resources/sound")) {
//                stream.write(audioData);
//            } catch (IOException e) {
//                throw new RuntimeException(e);
//            }

//            return LetterSoundRequest.builder()
//                    .letter(word)
//                    .sound(audioData)
//                    .build();

        } catch (Error e) {
            e.printStackTrace();
        }

        return null;
    }

    private Mono<Void> writeToFile(byte[] audioData) {
        System.out.println("writeToFile");
        try {
            String fileName = "output.mp3";
            Path filePath = Paths.get(fileName);
            File file = filePath.toFile();
            FileOutputStream outputStream = new FileOutputStream(file);
            outputStream.write(audioData);
            outputStream.close();
            System.out.println("File saved successfully at: " + file.getAbsolutePath());
            return Mono.empty();
        } catch (IOException e) {
            return Mono.error(e);
        }
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
