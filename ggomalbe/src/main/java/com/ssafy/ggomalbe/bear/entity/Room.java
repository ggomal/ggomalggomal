package com.ssafy.ggomalbe.bear.entity;

import lombok.Data;
import org.springframework.web.reactive.socket.WebSocketSession;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

import java.util.Arrays;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

//임시테스트용 룸 클래스
@Data
public class Room {
    private final String roomId;

    //방에 참여 하고 있는 사용자 정보 출력(세션아이디, 세션), 1:1 통신이라서 동시성을 고려할 필요가 없을거같다
    private final Map<String, WebSocketSession> participants = new HashMap<>();

    public Room(String roomId) {
        this.roomId = roomId;
    }

    private WebSocketSession kidSocket;
    private WebSocketSession teacherSocket;

    public void addParticipant(WebSocketSession session) {
        if(kidSocket == null){
            kidSocket = session;
        }else{
            teacherSocket = session;
        }
        participants.put(session.getId(), session);
    }

    public void removeParticipant(WebSocketSession session) {
        participants.remove(session.getId());
    }

    public Mono<Void> removeParticipantAsync(WebSocketSession session) {
        return Mono.fromRunnable(() -> participants.remove(session.getId()));
    }

    public Mono<Void> broadcast(String message) {
        // Flux.fromIterable(participants.values())를 통해 participants 맵의 모든 값을 Flux로 변환
        //Flux.fromIterable -> 리스트에서 flux생성
        // WebSocket 세션에 대한 스트림입니다.
        return Flux.fromIterable(participants.values())
                .flatMap(session ->session.send(Mono.just(session.textMessage(message)))) // flatMap을 사용하여 각 WebSocket 세션에 대해 비동기 작업을 수행하고 Mono로 반환
                .then();    // then()을 사용하여 모든 세션에게 메시지를 보낸 후에 Mono<Void>를 반환
    }

    //아이에게 빙고판 전달
    public Mono<Void> sendKidBingoBoard(BingoCard[][] board) {
        return kidSocket.send(Mono.just(kidSocket.textMessage(Arrays.toString(board)))).then();
    }

    //선생님에게 빙고판 전달
    public Mono<Void> sendTeacherBingoBoard(BingoCard[][] board) {
        return teacherSocket.send(Mono.just(teacherSocket.textMessage(Arrays.toString(board)))).then();
    }



    public boolean containsMember(WebSocketSession session){
        String sessionId = session.getId();
        for (String s : participants.keySet()) {
            if(s.equals(sessionId)) return true;
        }
        return false;
    }
}
