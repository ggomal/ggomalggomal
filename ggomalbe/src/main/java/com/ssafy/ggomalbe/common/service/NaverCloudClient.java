package com.ssafy.ggomalbe.common.service;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.ssafy.ggomalbe.bear.dto.LetterSoundRequest;
import com.ssafy.ggomalbe.bear.dto.SttResponse;
import com.ssafy.ggomalbe.common.dto.UploadResult;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatusCode;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Component;
import org.springframework.web.reactive.function.client.WebClient;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;
import reactor.core.scheduler.Schedulers;

import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.nio.ByteBuffer;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Date;
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

    public void getWordSound(String fileName, String word){
        String awsS3Path = "https://ggomalggomal.s3.ap-southeast-2.amazonaws.com/ggomal/sound/";
        // + "fileName/word.mp3"
        // URLEncoder.encode(word, "UTF-8");
        try {
            String text = URLEncoder.encode(word, StandardCharsets.UTF_8); // 13자
            String apiURL = "https://naveropenapi.apigw.ntruss.com/tts-premium/v1/tts";
            URL url = new URL(apiURL);
            HttpURLConnection con = (HttpURLConnection)url.openConnection();
            con.setRequestMethod("POST");
            con.setRequestProperty("X-NCP-APIGW-API-KEY-ID", CLIENT_ID);
            con.setRequestProperty("X-NCP-APIGW-API-KEY", CLIENT_SECRET);
            // post request
            String postParams = "speaker=ndain&volume=0&speed=0&pitch=0&format=mp3&text=" + text;
            con.setDoOutput(true);
            DataOutputStream wr = new DataOutputStream(con.getOutputStream());
            wr.writeBytes(postParams);
            wr.flush();
            wr.close();
            int responseCode = con.getResponseCode();
            BufferedReader br;
            if(responseCode==200) { // 정상 호출
                InputStream is = con.getInputStream();
                int read = 0;
                byte[] bytes = new byte[1024];
                // 랜덤한 이름으로 mp3 파일 생성
//                String tempname = Long.valueOf(new Date().getTime()).toString();
                String encodedFileName = URLEncoder.encode(word, StandardCharsets.UTF_8) + ".mp3";
                String directoryPath = "src/main/resources/sound/" + fileName;
                File directory = new File(directoryPath);
                if (!directory.exists()) {
                    directory.mkdirs(); // 디렉터리가 존재하지 않는 경우, 디렉터리를 생성합니다.
                }

                File f = new File(directory, encodedFileName); // 디렉터리와 파일 이름을 결합하여 새 파일 객체를 생성합니다.

                // 파일이 정상적으로 생성되었는지 확인
                System.out.println("File path: " + f.getAbsolutePath());

//                File f = new File();
                f.createNewFile();
                OutputStream outputStream = new FileOutputStream(f);
                while ((read =is.read(bytes)) != -1) {
                    outputStream.write(bytes, 0, read);
                }
                is.close();
            } else {  // 오류 발생
                br = new BufferedReader(new InputStreamReader(con.getErrorStream()));
                String inputLine;
                StringBuffer response = new StringBuffer();
                while ((inputLine = br.readLine()) != null) {
                    response.append(inputLine);
                }
                br.close();
                System.out.println(response.toString());
            }
        } catch (Exception e) {
            System.out.println(e);
        }
    }

    // 단어 -> 클로바 api로 전송
    // ** 여기서 안넘어감




    private Mono<Void> writeToFile(byte[] data) {
        System.out.println("writeToFile");
        return Mono.fromRunnable(() -> {
            String fileName = "/resources/sound/output.mp3";
            Path filePath = Paths.get(fileName);
            try (FileOutputStream outputStream = new FileOutputStream(filePath.toFile())) {
                outputStream.write(data);
            } catch (IOException e) {
                throw new RuntimeException(e);
            }
        }).subscribeOn(Schedulers.boundedElastic()).then();
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
