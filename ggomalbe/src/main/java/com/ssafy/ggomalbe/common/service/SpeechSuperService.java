package com.ssafy.ggomalbe.common.service;

import com.google.gson.Gson;
import com.ssafy.ggomalbe.common.dto.superspeech.PronunciationResDto;
import org.apache.commons.codec.binary.Hex;
import org.apache.commons.codec.digest.DigestUtils;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.MediaType;
import org.springframework.http.codec.multipart.FilePart;
import org.springframework.stereotype.Service;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.reactive.function.BodyInserters;
import org.springframework.web.reactive.function.client.WebClient;
import reactor.core.publisher.Mono;

import java.security.MessageDigest;

@Service
public class SpeechSuperService {

    @Value("${speechsuper.baseUrl}")
    private String baseUrl;

    @Value("${speechsuper.appKey}")
    private String appKey;

    @Value("${speechsuper.secretKey}")
    private String secretKey;

    @Value("${speechsuper.charString}")
    private String charString;

    private Mono<String> HttpAPI(FilePart file, String audioType, String audioSampleRate, String refText, String coreType) {
        String url = baseUrl + coreType;
        String userId = getRandomString(5);

        WebClient webClient = WebClient.create();

        String params = buildParam(appKey, secretKey, userId, audioType, audioSampleRate, refText, coreType);

        MultiValueMap<String, Object> body = new LinkedMultiValueMap<>();
        body.add("text", params);
        body.add("audio", file);

        return webClient.post()
                .uri(url)
                .header("Request-Index", "0")
                .contentType(MediaType.MULTIPART_FORM_DATA)
                .body(BodyInserters.fromMultipartData(body))
                .retrieve()
                .bodyToMono(String.class);
    }

    private String buildParam(String appkey, String secretKey, String userId, String audioType, String audioSampleRate, String refText, String coreType) {

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
                + "\"coreType\":\"" + coreType + "\","
                + "\"slack\":0.5"
                + "}"
                + "}"
                + "}"
                + "}";
        return params;
    }


    private int getRandom(int count) {
        return (int) Math.round(Math.random() * (count));
    }

    private String getRandomString(int length) {
        StringBuffer sb = new StringBuffer();
        int len = charString.length();
        for (int i = 0; i < length; i++) {
            sb.append(charString.charAt(getRandom(len - 1)));
        }
        return sb.toString();
    }

    public Mono<PronunciationResDto> evaluation(FilePart file, String refText) {
        String coreType = "sent.eval.kr"; // Change the coreType according to your needs.
        String audioType = "mp3"; // Change the audio type corresponding to the audio file.
        String audioSampleRate = "16000";

        return HttpAPI(file, audioType, audioSampleRate, refText, coreType)
                .map(result -> new Gson().fromJson(result, PronunciationResDto.class));
    }

    private Mono<PronunciationResDto> speechSuperWord(FilePart file, String refText) {
        String coreType = "word.eval.kr."; // Change the coreType according to your needs.
        String audioType = "mp3"; // Change the audio type corresponding to the audio file.
        String audioSampleRate = "16000";

        return HttpAPI(file, audioType, audioSampleRate, refText, coreType)
                .map(result -> new Gson().fromJson(result, PronunciationResDto.class));
    }
}