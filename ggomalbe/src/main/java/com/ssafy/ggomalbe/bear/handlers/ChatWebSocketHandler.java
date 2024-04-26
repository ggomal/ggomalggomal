package com.ssafy.ggomalbe.bear.handlers;

import com.ssafy.ggomalbe.bear.service.Chat;
import com.ssafy.ggomalbe.bear.service.ChatService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;
import org.springframework.web.reactive.socket.WebSocketHandler;
import org.springframework.web.reactive.socket.WebSocketSession;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

@RequiredArgsConstructor
@Slf4j
@Component
public class ChatWebSocketHandler implements WebSocketHandler {
    private final ChatService chatService;
    @Override
    public Mono<Void> handle(WebSocketSession session) {
//        String iam = (String) session.getAttributes().get("iam");
        String iam = session.getId();
        log.info("iam {}", iam);

        //A에서 B한테 보낼때 보낼수있는 방법이 있는가
        Flux<Chat> chatFlux = chatService.register(iam);
        chatService.sendChat(iam,
                new Chat(iam + "님 채팅방에 오신 것을 환영합니다", "system"));

        session.receive()
                .doOnNext(webSocketMessage -> {
                    log.info("webSocketMessage");
                    String payload = webSocketMessage.getPayloadAsText();
                    log.info("payload {}",payload);
                    String[] splits = payload.split(":");
                    String to = splits[0].trim();
                    String message = splits[1].trim()+" 안이다안이다";

                    boolean result = chatService.sendChat(to, new Chat(message, iam));
                    if (!result) {
                        chatService.sendChat(iam, new Chat("대화 상대가 없습니다", "system"));
                    }
                }).subscribe();
        //모든 skins를 들고와서 send를 해야한다
        return session.send(chatFlux
                        .doOnNext(n-> System.out.println("n"+" "+"호출"))
                .map(chat -> session.textMessage(chat.getFrom() + ": " + chat.getMessage()))
        );
    }
}
