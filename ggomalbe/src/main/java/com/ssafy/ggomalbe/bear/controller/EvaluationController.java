package com.ssafy.ggomalbe.bear.controller;

import com.ssafy.ggomalbe.bear.service.NaverCloudClient;
import lombok.RequiredArgsConstructor;
import lombok.Value;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.http.codec.multipart.FilePart;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

@RestController
@RequiredArgsConstructor
@Slf4j
public class EvaluationController {
    private final NaverCloudClient naverCloudClient;

    @PostMapping(value = "/bear/evaluation", produces = MediaType.TEXT_EVENT_STREAM_VALUE)
    public Flux<String> stt(@RequestPart("files") FilePart filePart) {
        return Flux.concat(
                Mono.just("loading..."),
                filePart
                        .content()
                        .flatMapSequential(dataBuffer -> Flux.fromIterable(dataBuffer::readableByteBuffers))
                        .reduce((b1, b2) -> {
                            b1.put(b2);
                            return b1;
                        })
                        .flatMap(buffer -> naverCloudClient.soundToText(buffer))
        );
    }


//    @PostMapping(value = "/sound-to-text-stream2", produces = MediaType.TEXT_EVENT_STREAM_VALUE)
//    public Flux<ServerSentEvent<String>> readBytes3(@RequestPart("files") FilePart filePart) {
//        return Flux.concat(
//                Flux.just(ServerSentEvent.<String>builder().data("로딩 중입니다...").build()), // 로딩 중임을 알리는 메시지 전송
//                filePart
//                        .content()
//                        .flatMapSequential(dataBuffer -> Flux.fromIterable(dataBuffer::readableByteBuffers))
//                        .reduce((b1, b2) -> {
//                            b1.put(b2);
//                            return b1;
//                        })
//                        .flatMap(buffer -> naverCloudClient.soundToText(buffer))
//                        .map(result -> ServerSentEvent.<String>builder().data(result).build()) // 결과 전송
//        );
//    }


//@PostMapping("/sound-to-text")
//public Mono<String> readBytes(@RequestPart("files") Flux<FilePart> fileParts) {
//    return fileParts
//            .flatMapSequential(filePart ->
//                    filePart
//                            .content()
//                            .flatMapSequential(dataBuffer ->
//                                    Flux.fromIterable(dataBuffer::readableByteBuffers))
//                            .reduce((buffer1, buffer2) -> {
//                                ByteBuffer combinedBuffer = ByteBuffer.allocate(buffer1.capacity() + buffer2.capacity());
//                                combinedBuffer.put(buffer1);
//                                combinedBuffer.put(buffer2);
//                                return combinedBuffer;
//                            })
//                            .flatMap(naverCloudClient::soundToText)
//            )
//            .collectList()
//            .map(list -> String.join(", ", list)); // 결과를 적절하게 처리하여 하나의 Mono<String>으로 반환
//}
}