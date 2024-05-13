package com.ssafy.ggomalbe.bear.handlers;

import com.ssafy.ggomalbe.bear.entity.Chat;
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
        System.out.println("name " + session.getHandshakeInfo().getHeaders().get("name").get(0));
        String iam = session.getHandshakeInfo().getHeaders().get("name").get(0);

        //A에서 B한테 보낼때 보낼수있는 방법이 있는가
        //소켓으로 대상을 찾고 sink로 메시지를 보낸다 -> 비동기
        Flux<Chat> chatFlux = chatService.register(iam);
        chatService.sendChat(iam,
                new Chat(iam + "님 채팅방에 오신 것을 환영합니다", "system"));

        //아 리시브하면 싱크에 값을 밀어넣고, 싱크는 그걸 인지하고 샌드를 호출하는건가, 의문점으로 싱크가 변하는데 왜 session.send가 호출되는건지
        //클라이언트에서 데이터를 보내면 여기서 받아서 sink로 내가 보내고자 하는 사람에게 보낸다. 소켓으로 보내는게 아니다!
        session.receive()
                .flatMap(webSocketMessage -> {
                    System.out.println("receive"+" "+session.getId());
                    String payload = webSocketMessage.getPayloadAsText();
                    String[] splits = payload.split(":");
                    String to = splits[0].trim();
                    String message = splits[1].trim();

                    boolean result = chatService.sendChat(to, new Chat(message, iam));
                    chatService.sendChat(iam, new Chat(message, iam));
                    if (!result) {
                        chatService.sendChat(iam, new Chat("대화 상대가 없습니다", "system"));
                    }
                    return Mono.empty();
                }).subscribe();

        //session.send가 저장되는것(호출되는것)이 아니라 chatFlux가 session.send에 저장되어있는것..!(send가 플럭스의 변화를 감지한다) 핵심
        return session.send(
                chatFlux
                        .doOnNext(chat -> System.out.println("send" + " " + session.getId()))
                        .map(chat -> session.textMessage(chat.getFrom() + ": " + chat.getMessage()))
        );
    }
}
