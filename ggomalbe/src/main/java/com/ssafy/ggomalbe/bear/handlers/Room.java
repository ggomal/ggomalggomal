package com.ssafy.ggomalbe.bear.handlers;

import lombok.Data;
import org.springframework.web.reactive.socket.WebSocketSession;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

import java.util.concurrent.ConcurrentHashMap;

//임시테스트용 룸 클래스
@Data
public class Room {
    private final String roomId;
    private final ConcurrentHashMap<String, WebSocketSession> participants = new ConcurrentHashMap<>();

    public Room(String roomId) {
        this.roomId = roomId;
    }

    public void addParticipant(WebSocketSession session) {
        participants.put(session.getId(), session);
    }

    public void removeParticipant(WebSocketSession session) {
        participants.remove(session.getId());
    }

    public Mono<Void> broadcast(String message) {
        // Flux.fromIterable(participants.values())를 통해 participants 맵의 모든 값을 Flux로 변환
        //Flux.fromIterable -> 리스트에서 flux생성
        // WebSocket 세션에 대한 스트림입니다.
        return Flux.fromIterable(participants.values())
                .flatMap(session -> session.send(Mono.just(session.textMessage(message)))) // flatMap을 사용하여 각 WebSocket 세션에 대해 비동기 작업을 수행하고 Mono로 반환
                .then();    // then()을 사용하여 모든 세션에게 메시지를 보낸 후에 Mono<Void>를 반환합니다
    }
}
