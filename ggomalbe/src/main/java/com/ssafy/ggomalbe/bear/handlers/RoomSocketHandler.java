package com.ssafy.ggomalbe.bear.handlers;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.ssafy.ggomalbe.bear.service.BingoSocketService;
import com.ssafy.ggomalbe.bear.service.RoomService;
import com.ssafy.ggomalbe.bear.service.TeacherSocketService;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;
import org.springframework.web.reactive.socket.WebSocketHandler;
import org.springframework.web.reactive.socket.WebSocketSession;
import reactor.core.publisher.Mono;

import java.io.IOException;

@Component
@Slf4j
@RequiredArgsConstructor
@Getter
public class RoomSocketHandler implements WebSocketHandler {

    private final ObjectMapper objectMapper;
    private final RoomService roomService;
    private final BingoSocketService bingoSocketService;
    private final TeacherSocketService teacherSocketService;

    @Override
    public Mono<Void> handle(WebSocketSession session) {
        log.info("room-socket sessionId {}", session.getId());

        return session.receive()                                // WebSocket 세션을 통해 클라이언트로부터 메시지를 수신
                .map(message ->message.getPayloadAsText())      //수신된 각 메시지 텍스트 형식으로 변환
                .flatMap(message -> {                           //비동기 처리를 위한 flatMap, 처리하고 Mono로 반환하여 새로운 Publisher생성
                    try {
                        JsonNode jsonNode = objectMapper.readTree(message);
                        if(jsonNode.get("type") == null) return Mono.empty();
                        String messageType = jsonNode.get("type").asText();
                        log.info("message type {}", messageType);
                        return switch (messageType) {
                            case "joinRoom" -> roomService.joinRoom(jsonNode, session);
                            case "createRoom" -> roomService.createRoom(jsonNode, session);
                            case "sendMessage" -> roomService.sendMessage(jsonNode, session);
                            //삭제 플러그가 아니라. 두명이 다 leaveRoom하면 delete
                            case "deleteRoom" -> roomService.deleteRoom(jsonNode,session);
                            case "leaveRoom" -> roomService.leaveRoom(session);
                            case "setBingoBoard" ->teacherSocketService.setBingoBoard(session);
                            case "choiceBingo" -> teacherSocketService.choiceBingoCard(session,jsonNode.get("message").asText());
                            case "printBingoV" -> bingoSocketService.printBingoV(session);
                            default -> Mono.empty();
                        };
                    } catch (IOException e) {
                        return Mono.error(new IllegalArgumentException("Invalid JSON format"));
                    }
                })
                .doFinally(signalType -> {
                    //then은 비동기 작업을 순차적으로 실행하고 싶을 때 사용(이전 작업이 완료(empty여도 상관없음)되어야 실행)
                    // WebSocket 연결이 종료될 때 해당 세션을 방에서 제거
//                    roomService.rooms.values().forEach(room -> room.removeParticipant(session));
                    roomService.leaveRoom(session).subscribe();
                })
                .then();    //모든 처리가 완료된 후에 Mono<Void>를 반환
    }
}