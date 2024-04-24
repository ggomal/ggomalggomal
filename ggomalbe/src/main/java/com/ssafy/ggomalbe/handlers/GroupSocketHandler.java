package com.ssafy.ggomalbe.handlers;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.stereotype.Component;
import org.springframework.web.reactive.HandlerMapping;
import org.springframework.web.reactive.socket.WebSocketHandler;
import org.springframework.web.reactive.socket.WebSocketMessage;
import org.springframework.web.reactive.socket.WebSocketSession;
import org.springframework.web.reactive.socket.server.support.WebSocketHandlerAdapter;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

@Component
public class GroupSocketHandler implements WebSocketHandler {

    //빙고에서 아이가 생성한 룸관리, 선생님을 참가시키기위한 해시맵
    private final Map<String, Room> rooms = new HashMap<>();

    //JSON파일 파싱
    private final ObjectMapper objectMapper;

    public GroupSocketHandler(ObjectMapper objectMapper) {
        this.objectMapper = objectMapper;
    }

    @Override
    public Mono<Void> handle(WebSocketSession session) {
        return session.receive()                            // WebSocket 세션을 통해 클라이언트로부터 메시지를 수신
                .map(WebSocketMessage::getPayloadAsText)    //수신된 각 메시지 텍스트 형식으로 변환
                .flatMap(message -> {                       //비동기 처리를 위한 flatMap
                    try {
                        JsonNode jsonNode = objectMapper.readTree(message);
                        String messageType = jsonNode.get("type").asText();
                        switch (messageType) {
                            case "joinRoom":
                                return joinRoom(jsonNode, session);
                            case "createRoom":
                                return createRoom(jsonNode, session);
                            case "sendMessage":
                                return sendMessage(jsonNode);
                            case "deleteRoom":
                                return deleteRoom(jsonNode);
                            default:
                                return Mono.error(new IllegalArgumentException("Invalid message type"));
                        }
                    } catch (IOException e) {
                        return Mono.error(new IllegalArgumentException("Invalid JSON format"));
                    }
                })
                .doFinally(signalType -> {

                    // WebSocket 연결이 종료될 때 (finally) 해당 세션을 방에서 제거
                    rooms.values().forEach(room -> room.removeParticipant(session));
                })
                .then();
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
            return Mono.error(new IllegalArgumentException("Room not found: " + roomId));
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

    private Mono<Void> sendMessage(JsonNode jsonNode) {
        String roomId = jsonNode.get("roomId").asText();
        String message = jsonNode.get("message").asText();
        Room room = rooms.get(roomId);
        if (room != null) {
            //같은 룸에 있는 사용자에게
            return room.broadcast(message);
        } else {
            return Mono.error(new IllegalArgumentException("Room not found: " + roomId));
        }
    }

    private Mono<Void> deleteRoom(JsonNode jsonNode) {
        String roomId = jsonNode.get("roomId").asText();
        rooms.remove(roomId);
        return Mono.empty();
    }
}

//임시테스트용 룸 클래스
class Room {

    private final String roomId;
    private final Map<String, WebSocketSession> participants = new HashMap<>();

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
        // WebSocket 세션에 대한 스트림입니다.
        return Flux.fromIterable(participants.values())
                .flatMap(session -> session.send(Mono.just(session.textMessage(message)))) // flatMap을 사용하여 각 WebSocket 세션에 대해 비동기 작업을 수행하고 Mono로 반환
                .then();    // then()을 사용하여 모든 세션에게 메시지를 보낸 후에 Mono<Void>를 반환합니다
    }
}
