package com.ssafy.ggomalbe.common.service;

import jakarta.annotation.PostConstruct;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Component;
import org.springframework.web.reactive.function.client.WebClient;
import reactor.core.publisher.Mono;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

@Slf4j
@Component
public class S3Client {
    @Value("${aws.s3.bucketName}")
    private String BUCKET_NAME;

    @Value("${aws.s3.region}")
    private String REGION;

    @Value("${aws.s3.auth}")
    private String AUTHENTICATION;

    @Value("${aws.s3.x-amz-content-sha256}")
    private String AMZ_CONTENT;

    private String baseUrl;
    private WebClient s3Client;

    public S3Client() {
    }
    @PostConstruct
    public void init(){
        baseUrl = "https://"+BUCKET_NAME+".s3."+REGION+".amazonaws.com";
        s3Client = WebClient.builder()
                .baseUrl(baseUrl)
                .defaultHeader("Authorization", AUTHENTICATION)
                .defaultHeader("X-Amz-Content-Sha256", AMZ_CONTENT)
                .build();
    }

    public Mono<String> postImg(String user, String file){
        String filename = "/ggomal/userImg/"+user+".jpg";
        return s3Client.put()
                .uri(filename)
                .contentType(MediaType.MULTIPART_FORM_DATA)
                .header("X-Amz-Date", LocalDateTime.now().minusHours(9L).format(DateTimeFormatter.ofPattern("yyyyMMdd'T'HHmmss'Z'")))
                .body(Mono.just(file),String.class)
                .exchangeToMono(response -> {
                    if (response.statusCode().equals(HttpStatus.OK)) {
                        return response.bodyToMono(HttpStatus.class).thenReturn(response.statusCode());
                    } else {
                        System.out.println("Error uploading file");
                        return response.bodyToMono(String.class);
                    }
                })
                .map(s -> {
                    System.out.println(s);
                    return baseUrl+filename;
                });
    }

}
