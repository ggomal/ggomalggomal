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
import org.springframework.web.reactive.socket.WebSocketMessage;
import org.springframework.web.reactive.socket.WebSocketSession;
import reactor.core.publisher.Mono;
import reactor.core.scheduler.Schedulers;

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
                .map(WebSocketMessage::getPayloadAsText)        //수신된 각 메시지 텍스트 형식으로 변환
                .flatMap(message -> {                           //비동기 처리를 위한 flatMap, 처리하고 Mono로 반환하여 새로운 Publisher생성
                    try {
                        log.info("socket message parsing start");
                        JsonNode jsonNode = objectMapper.readTree(message);
                        if (jsonNode.get("type") == null) {
                            log.info("type null");
                            return Mono.empty();
                        }

                        String messageType = jsonNode.get("type").asText();
                        log.info("message type {}", messageType);

                        return switch (messageType) {
                            case "joinRoom" -> roomService.joinRoom(jsonNode, session);

                            //아이가 방을 만들때
                            case "createRoom" -> roomService.createRoom(jsonNode, session);
                            case "sendMessage" -> roomService.sendMessage(jsonNode, session);


                            case "countRoomMember" -> roomService.countRoomMember(session);
                            case "countRoom" -> roomService.countRoom();



                            //삭제 플러그가 아니라. 두명이 다 leaveRoom하면 delete
                            case "leaveRoom" -> roomService.leaveRoom(session);
                            case "setBingoBoard" -> teacherSocketService.setBingoBoard(session, jsonNode);
                            case "printBingoV" -> bingoSocketService.printBingoV(session);

                            //선생님이 통과를 누르면 아이는 음성데이터를 보내고, 빙고보드에 O친다
                            //case "markingBingoCard" -> teacherSocketService.markingBingoCard(session,jsonNode);

                            // 번갈아가며 선택
                            case "play" -> teacherSocketService.play(session, jsonNode);

                            //선생님 차례일때, 아이가 같은 카드를 선택하면 평가모드
                            case "evaluation" -> teacherSocketService.evaluation(session, jsonNode);

                            //선생님이 통과를 선택했을때 아이가 가지고 있는 음성데이터를 보내라고 한다
                            case "requestVoice" -> teacherSocketService.requestVoice(session, jsonNode);
                            default -> Mono.empty();
                        };
                    } catch (IOException e) {
                        return Mono.error(new IllegalArgumentException("Invalid JSON format"));
                    }
                })
                .publishOn(Schedulers.boundedElastic())
                .doFinally(signalType -> {

                    //애가 떠날때는 선생님에게 떠난다고하기
                    log.info("socket doFinally");
                    roomService.leaveRoom(session).subscribe();
                })
                .then();    //모든 처리가 완료된 후에 Mono<Void>를 반환
    }
}