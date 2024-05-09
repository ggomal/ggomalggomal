package com.ssafy.ggomalbe.fastApi;

import jakarta.annotation.PostConstruct;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.codec.multipart.FilePart;
import org.springframework.stereotype.Service;
import org.springframework.web.reactive.function.client.WebClient;
import reactor.core.publisher.Mono;

@Service
public class FastApiService {
    private final WebClient webClient;

    @Value("${fastApi.baseUrl}")
    private String fastApiUrl;

    public FastApiService() {
        this.webClient = WebClient.builder().build();;
    }

    @PostConstruct
    public void init(){
        this.webClient.mutate().baseUrl(fastApiUrl);
    }

    public Mono<Boolean> getTongue(FilePart frogGameImg) {
        return this.webClient.post()
                .uri("/fast/mf_recom/update")
                .bodyValue(frogGameImg)
                .retrieve()
                .onStatus(httpStatus -> httpStatus.is4xxClientError() || httpStatus.is5xxServerError(),
                        clientResponse -> Mono.error(new RuntimeException("API 호출 실패, 상태 코드: " + clientResponse.statusCode())))
                .bodyToMono(Boolean.class);
    }

//    @Data
//    @AllArgsConstructor
//    @NoArgsConstructor
//    static public class MfRecommendResponse {
//
//        @JsonProperty("news_seq")
//        private Long newsSeq;
//
//        @JsonProperty("news_title")
//        private String title;
//
//        @JsonProperty("news_similarity")
//        private Double similarity;
//    }
//    @Data
//    @AllArgsConstructor
//    @NoArgsConstructor
//    static public class CbfRecommendResponse {
//
//        private String news_id;
//
//        private Long news_seq;
//
//        private String news_title;
//
//        private Double news_similarity;
//
//        private Map<String, Double> news_keyword;
//
//    }
}
