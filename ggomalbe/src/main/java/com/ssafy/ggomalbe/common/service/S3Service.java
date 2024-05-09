package com.ssafy.ggomalbe.common.service;

import com.ssafy.ggomalbe.common.config.S3ClientConfigurationProperties;
import com.ssafy.ggomalbe.common.dto.UploadResult;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;
import software.amazon.awssdk.core.async.AsyncRequestBody;
import software.amazon.awssdk.services.s3.S3AsyncClient;
import software.amazon.awssdk.services.s3.model.PutObjectRequest;
import software.amazon.awssdk.services.s3.model.PutObjectResponse;

import java.nio.ByteBuffer;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;
import java.util.concurrent.CompletableFuture;

@Service
@RequiredArgsConstructor
public class S3Service {

    private final S3AsyncClient s3client;
    private final S3ClientConfigurationProperties s3config;

    public Mono<ResponseEntity<UploadResult>> uploadHandler(String fileKey, Flux<ByteBuffer> file) {
        Map<String, String> metadata = new HashMap<String, String>();
        MediaType mediaType = MediaType.APPLICATION_OCTET_STREAM;

        // fileKey가 s3에 저장될 이름입니다.
        CompletableFuture<PutObjectResponse> future = s3client
                .putObject(PutObjectRequest.builder()
                                .bucket(s3config.getBucket())
                                .key(fileKey)
                                .contentType(mediaType.toString())
                                .metadata(metadata)
                                .build(),
                        AsyncRequestBody.fromPublisher(file));

        return Mono.fromFuture(future)
                .map((response) -> {
                    return ResponseEntity
                            .status(HttpStatus.CREATED)
                            .body(new UploadResult(HttpStatus.CREATED, new String[] {fileKey}));
                });
    }

}
