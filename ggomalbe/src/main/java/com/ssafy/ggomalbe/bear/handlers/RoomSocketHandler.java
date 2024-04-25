package com.ssafy.ggomalbe.bear.handlers;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.ssafy.ggomalbe.bear.entity.Room;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;
import org.springframework.web.reactive.socket.WebSocketHandler;
import org.springframework.web.reactive.socket.WebSocketMessage;
import org.springframework.web.reactive.socket.WebSocketSession;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

import java.io.IOException;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;

@Component
@Slf4j
@AllArgsConstructor
@Getter
public class RoomSocketHandler implements WebSocketHandler {

    //빙고에서 아이가 생성한 룸관리, 선생님을 참가시키기위한 해시맵
    //ConcurrentHashMap은 스프링 빈이 아니라서 따로 관리해주어야한다. 근데 내부적으로 동기화를 진행한다는데 flux로 했을때 효율적인지
    // gpt :  여러 스레드가 동시에 ConcurrentHashMap에 접근하면 잠금 충돌이 더 자주 발생할 수 있습니다. 이는 동시성을 높이고 병렬 처리를 통해 처리량을 향상시키는 Flux의 장점과 상충될 수 있습니다.
    // create한 room 저장
    private final ConcurrentHashMap<String, Room> rooms;

    //JSON파일 파싱
    private final ObjectMapper objectMapper;

    @Override
    public Mono<Void> handle(WebSocketSession session) {
        log.info("room-socket sessionId {}", session.getId());
        return session.receive()                            // WebSocket 세션을 통해 클라이언트로부터 메시지를 수신
                .map(WebSocketMessage::getPayloadAsText)    //수신된 각 메시지 텍스트 형식으로 변환
                .flatMap(message -> {                       //비동기 처리를 위한 flatMap, 처리하고 Mono로 반환하여 새로운 Publisher생성
                    try {
                        JsonNode jsonNode = objectMapper.readTree(message);
                        String messageType = jsonNode.get("type").asText();
                        switch (messageType) {
                            case "joinRoom":
                                return joinRoom(jsonNode, session);
                            case "createRoom":
                                return createRoom(jsonNode, session);
                            case "sendMessage":
                                return sendMessage(jsonNode, session);
                            //삭제 플러그가 아니라. 두명이 다 leaveRoom하면 delete
                            case "deleteRoom":
                                return deleteRoom(jsonNode);
                            default:
                                return Mono.empty();
                        }
                    } catch (IOException e) {
                        return Mono.error(new IllegalArgumentException("Invalid JSON format"));
                    }
                })
                .doFinally(signalType -> {
                    // WebSocket 연결이 종료될 때 해당 세션을 방에서 제거
                    rooms.values().forEach(room -> room.removeParticipant(session));
                })
                .then();    //모든 처리가 완료된 후에 Mono<Void>를 반환
    }

    private Mono<Void> joinRoom(JsonNode jsonNode, WebSocketSession session) {
        String roomId = jsonNode.get("roomId").asText();
        Room room = rooms.get(roomId);
        if (room != null) {
            room.addParticipant(session);
            //WebSocket 세션을 통해 메시지를 클라이언트에게 보내는 작업 수행
            //비동기적으로 실행되며, 클라이언트에게 메시지를 성공적으로 보내면 Mono<Void>를 반환
            return session.send(Mono.just(session.textMessage("Joined room: " + roomId)));
        } else {
//            return Mono.error(new IllegalArgumentException("Room not found: " + roomId));
            return Mono.empty();
        }
    }


    private Mono<Void> createRoom(JsonNode jsonNode, WebSocketSession session) {
        String roomId = jsonNode.get("roomId").asText();
        if (!rooms.containsKey(roomId)) {
            Room room = new Room(roomId);
            rooms.put(roomId, room);
            room.addParticipant(session);
            return session.send(Mono.just(session.textMessage("Room created: " + roomId)));
        } else {
            return session.send(Mono.just(session.textMessage("Room already exists: " + roomId)));
        }
    }


    private Mono<Void> sendMessage(JsonNode jsonNode, WebSocketSession session) {
        String roomId = jsonNode.get("roomId").asText();
        String message = jsonNode.get("message").asText();
        Room room = rooms.get(roomId);

        //메시지를 보낼때 내가 그 방에 참가 하고 있어야 보낼수 있다.
        if (room != null && room.containsMember(session)) {
            //같은 룸에 있는 사용자에게
            return room.broadcast(message);
        } else {
//            return Mono.error(new IllegalArgumentException("Room not found: " + roomId));
            return Mono.empty();
        }
    }

    private Mono<Void> deleteRoom(JsonNode jsonNode) {
        return Mono.fromRunnable(() -> {
            String roomId = jsonNode.get("roomId").asText();
            rooms.remove(roomId);
        });
    }

    //나가기, 뒤로 버튼 누를시
    //어떤 사람이 어떤 방에있는지, 어떤 방에 어떤 사람이 있는지
    //roomf
    private void leaveRoom(WebSocketSession session) {

        // 모든 방을 반복하면서 해당 세션을 제거
        rooms.values().forEach(room -> room.removeParticipant(session));

        // 더 이상 방에 참가자가 없는 방을 제거
        rooms.entrySet().removeIf(entry -> entry.getValue().getParticipants().isEmpty());
    }
}