package com.ssafy.ggomalbe.common.service;

import com.ssafy.ggomalbe.common.config.S3ClientConfigurationProperties;
import com.ssafy.ggomalbe.common.dto.UploadResult;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;
import software.amazon.awssdk.core.async.AsyncRequestBody;
import software.amazon.awssdk.services.s3.S3AsyncClient;
import software.amazon.awssdk.services.s3.model.PutObjectRequest;
import software.amazon.awssdk.services.s3.model.PutObjectResponse;

import java.nio.ByteBuffer;
import java.util.HashMap;
import java.util.Map;
import java.util.Optional;
import java.util.UUID;
import java.util.concurrent.CompletableFuture;

@Service
@RequiredArgsConstructor
public class S3Service {
    private final S3AsyncClient s3client;
    private final S3ClientConfigurationProperties s3config;


    // length = header길이, fileKey = 저장되는 파일 경로 + 이름, mediaType = 미디어타입, metadata =
    public Mono<ResponseEntity<UploadResult>> uploadHandler(HttpHeaders headers, Flux<ByteBuffer> body) {
        long length = headers.getContentLength();

        Map<String, String> metadata = new HashMap<String, String>();
        MediaType mediaType = headers.getContentType();

        if (mediaType == null) {
            mediaType = MediaType.APPLICATION_OCTET_STREAM;
        }

        // fileKey가 s3에 저장될 이름입니다.
        String fileKey = UUID.randomUUID().toString() + "." + mediaType.getSubtype();

        CompletableFuture<PutObjectResponse> future = s3client
                .putObject(PutObjectRequest.builder()
                                .bucket(s3config.getBucket())
                                .contentLength(length)
                                .key(fileKey)
                                .contentType(mediaType.toString())
                                .metadata(metadata)
                                .build(),
                        AsyncRequestBody.fromPublisher(body));

        return Mono.fromFuture(future)
                .map((response) -> {
                    return ResponseEntity
                            .status(HttpStatus.CREATED)
                            .body(new UploadResult(HttpStatus.CREATED, new String[] {fileKey}));
                });
    }
}
