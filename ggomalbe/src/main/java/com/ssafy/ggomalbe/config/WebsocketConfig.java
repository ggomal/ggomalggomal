package com.ssafy.ggomalbe.config;

import com.ssafy.ggomalbe.handlers.GroupSocketHandler;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.reactive.handler.SimpleUrlHandlerMapping;
import org.springframework.web.reactive.socket.WebSocketHandler;
import org.springframework.web.reactive.socket.server.support.WebSocketHandlerAdapter;
import reactor.core.publisher.Sinks;

import java.util.Map;

@Configuration
public class WebsocketConfig {

    /**
     * WebSocket 요청을 처리하기 위한 URL 매핑
     * SimpleUrlHandlerMapping은 URL 패턴과 WebSocketHandler 사이의 매핑을 제공
     * /ws-bingo 경로에 대한 WebSocketHandler를 등록
     */
    @Bean
    public SimpleUrlHandlerMapping handlerMapping(GroupSocketHandler wsh) {
        return new SimpleUrlHandlerMapping(Map.of("/ws-bingo", wsh), 1);
    }

    /**
     * WebSocketHandlerAdapter를 빈으로 등록합니다.
     * WebSocketHandlerAdapter는 Spring WebFlux의 WebSocketHandler를 처리할 수 있도록 해줌.
     */
    @Bean
    public WebSocketHandlerAdapter webSocketHandlerAdapter() {
        return new WebSocketHandlerAdapter();
    }

    /**
     * 다수의 구독자에게 메시지를 방출할 수 있는 Sinks.Many 빈을 생성
     * Sinks.many().multicast().directBestEffort()를 호출하여 multicast 및 directBestEffort 모드로 동작하는 Sinks.Many를 생성
     * 클라이언트로부터 받은 메시지를 여러 구독자에게 방출하기 위해 사용
     */
    @Bean
    public Sinks.Many<String> sink() {
        return Sinks.many().multicast().directBestEffort();
    }

}
