package com.ssafy.ggomalbe.bear.controller;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.ssafy.ggomalbe.common.dto.SpeechDto;
import org.apache.commons.codec.binary.Hex;
import org.apache.commons.codec.digest.DigestUtils;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.codec.multipart.FilePart;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.reactive.function.BodyInserters;
import org.springframework.web.reactive.function.client.WebClient;
import reactor.core.publisher.Mono;

import java.security.MessageDigest;
import java.util.Map;

@RestController
@RequestMapping("/super")
public class SuperSpeechController {

    //    appKey/applicationId: 17153308990002fe
//    secretKey:3b848e012b72b120898b2ceb934ac83d
    public static final String baseUrl = "https://api.speechsuper.com/";
    public static final String appKey = "17153308990002fe";
    public static final String secretKey = "3b848e012b72b120898b2ceb934ac83d";


    public static Mono<String> HttpAPI(FilePart file, String audioType, String audioSampleRate, String refText, String coreType) {
        String url = baseUrl + coreType;
        String userId = getRandomString(5);

        WebClient webClient = WebClient.create();

        String params = buildParam(appKey, secretKey, userId, audioType, audioSampleRate, refText, coreType);

        MultiValueMap<String, Object> body = new LinkedMultiValueMap<>();
        body.add("text", params);
        body.add("audio", file);
        System.out.println(body.get("audio"));

        return webClient.post()
                .uri(url)
//                                .header(HttpHeaders.CONTENT_TYPE, MediaType.MULTIPART_FORM_DATA_VALUE)
                .header("Request-Index", "0")
                .body(BodyInserters.fromMultipartData(body))
                .retrieve()
                .bodyToMono(String.class);
    }

    private static String buildParam(String appkey, String secretKey, String userId, String audioType, String audioSampleRate, String refText, String coreType) {

        MessageDigest digest = DigestUtils.getSha1Digest();

        long timeReqMillis = System.currentTimeMillis();
        String connectSigStr = appkey + timeReqMillis + secretKey;
        String connectSig = Hex.encodeHexString(digest.digest(connectSigStr.getBytes()));

        long timeStartMillis = System.currentTimeMillis();
        String startSigStr = appkey + timeStartMillis + userId + secretKey;
        String startSig = Hex.encodeHexString(digest.digest(startSigStr.getBytes()));
        //request param
        String params = "{"
                + "\"connect\":{"
                + "\"cmd\":\"connect\","
                + "\"param\":{"
                + "\"sdk\":{"
                + "\"protocol\":2,"
                + "\"version\":16777472,"
                + "\"source\":9"
                + "},"
                + "\"app\":{"
                + "\"applicationId\":\"" + appkey + "\","
                + "\"sig\":\"" + connectSig + "\","
                + "\"timestamp\":\"" + timeReqMillis + "\""
                + "}"
                + "}"
                + "},"
                + "\"start\":{"
                + "\"cmd\":\"start\","
                + "\"param\":{"
                + "\"app\":{"
                + "\"applicationId\":\"" + appkey + "\","
                + "\"timestamp\":\"" + timeStartMillis + "\","
                + "\"sig\":\"" + startSig + "\","
                + "\"userId\":\"" + userId + "\""
                + "},"
                + "\"audio\":{"
                + "\"sampleBytes\":2,"
                + "\"channel\":1,"
                + "\"sampleRate\":" + audioSampleRate + ","
                + "\"audioType\":\"" + audioType + "\""
                + "},"
                + "\"request\":{"
                + "\"tokenId\":\"tokenId\","
                + "\"refText\":\"" + refText + "\","
                + "\"coreType\":\"" + coreType + "\""
                + "}"
                + "}"
                + "}"
                + "}";
        return params;
    }


    private static int getRandom(int count) {
        return (int) Math.round(Math.random() * (count));
    }

    private static final String charString = "abcdefghijklmnopqrstuvwxyz123456789";

    private static String getRandomString(int length) {
        StringBuffer sb = new StringBuffer();
        int len = charString.length();
        for (int i = 0; i < length; i++) {
            sb.append(charString.charAt(getRandom(len - 1)));
        }
        return sb.toString();
    }

    @PostMapping
    public Mono<Void> superSpeech(@RequestPart("file") FilePart file) {
        System.out.println("api호출시작");
        String coreType = "sent.eval.kr"; // Change the coreType according to your needs.
        String refText = "피망 넣어주세요"; // Change the reference text according to your needs.
        String audioPath = "src/main/resources/audio/InsertTomato.mp3"; // Change the audio path corresponding to the reference text.
        String audioType = "mp3"; // Change the audio type corresponding to the audio file.
        String audioSampleRate = "16000";
        Gson gson = new GsonBuilder()
                .setPrettyPrinting()
                .create();

        return HttpAPI(file, audioType, audioSampleRate, refText, coreType)
                .doOnNext(result->{
                    System.out.println(result);
                }).then();

    }
}