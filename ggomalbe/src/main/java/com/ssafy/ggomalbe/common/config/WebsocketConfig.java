package com.ssafy.ggomalbe.common.config;

import com.ssafy.ggomalbe.bear.handlers.ChatWebSocketHandler;
import com.ssafy.ggomalbe.bear.handlers.KidSocketHandler;
import com.ssafy.ggomalbe.bear.handlers.RoomSocketHandler;
import com.ssafy.ggomalbe.bear.handlers.TeacherSocketHandler;
import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.reactive.handler.SimpleUrlHandlerMapping;
import org.springframework.web.reactive.socket.WebSocketHandler;

import java.util.HashMap;
import java.util.Map;

@Configuration
@RequiredArgsConstructor
public class WebsocketConfig{

    private final RoomSocketHandler roomSocketHandler;
    private final KidSocketHandler kidSocketHandler;
    private final TeacherSocketHandler teacherSocketHandler;

    private final ChatWebSocketHandler chatWebSocketHandler;

    /**
     * WebSocket 요청을 처리하기 위한 URL 매핑
     * SimpleUrlHandlerMapping은 URL 패턴과 WebSocketHandler 사이의 매핑을 제공
     * /ws-bingo 경로에 대한 WebSocketHandler를 등록
     */
    @Bean
    public SimpleUrlHandlerMapping handlerMapping() {
        Map<String, WebSocketHandler> map = new HashMap<>();
        map.put("/room", roomSocketHandler);
        map.put("/kid", kidSocketHandler);
        map.put("/teacher", teacherSocketHandler);
        map.put("/chat", chatWebSocketHandler);

        SimpleUrlHandlerMapping mapping = new SimpleUrlHandlerMapping();
        mapping.setOrder(1);
        mapping.setUrlMap(map);
        return mapping;
    }

    /**
     * WebSocketHandlerAdapter를 빈으로 등록합니다.
     * WebSocketHandlerAdapter는 Spring WebFlux의 WebSocketHandler를 처리할 수 있도록 해줌.
     * 그런데! 웹 플럭스에서는 내부적으로 사용하는것이 있어서 따로 어뎁터를 빈으로 등록하지 않아도 된다
     */
//    @Bean
//    public WebSocketHandlerAdapter webSocketHandlerAdapter() {
//        return new WebSocketHandlerAdapter();
//    }

    /**
     * 다수의 구독자에게 메시지를 방출할 수 있는 Sinks.Many 빈을 생성
     * Sinks.many().multicast().directBestEffort()를 호출하여 multicast 및 directBestEffort 모드로 동작하는 Sinks.Many를 생성
     * 클라이언트로부터 받은 메시지를 여러 구독자에게 방출하기 위해 사용
     */
//    @Bean
//    public Sinks.Many<String> sink() {
//        return Sinks.many().multicast().directBestEffort();
//    }

}
