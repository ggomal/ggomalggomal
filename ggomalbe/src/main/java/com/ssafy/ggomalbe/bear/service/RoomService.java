package com.ssafy.ggomalbe.bear.service;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.ssafy.ggomalbe.bear.dto.CreateRoomResponse;
import com.ssafy.ggomalbe.bear.dto.ErrorResponse;
import com.ssafy.ggomalbe.bear.entity.Room;
import com.ssafy.ggomalbe.bear.entity.SocketAction;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.core.context.ReactiveSecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.web.reactive.socket.WebSocketSession;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

import java.util.Map;
import java.util.UUID;
import java.util.concurrent.ConcurrentHashMap;

@Service
@Slf4j
@RequiredArgsConstructor
public class RoomService {
    // roomId와 Room mapping
    private static final Map<String, Room> rooms = new ConcurrentHashMap<>();

    // 해당 아이디인 멤버가 어떤 Room에 있는지(sessionId 를  memberId로 변경해야함)
    private static final Map<String,Room> memberRoom = new ConcurrentHashMap<>();

    private final ObjectMapper objectMapper;

    // 멤버의 아이디로 멤버가 참하고 있는 방을 return
    public Room findRoomByMemberId(String id){
        return memberRoom.get(id);
    }

    public Room getRoom(String id){
        return rooms.get(id);

    }

    public Mono<Void> createRoom(JsonNode jsonNode, WebSocketSession session) throws JsonProcessingException {
        log.info("createRoom");
        String roomId = createRoomNumber();
        if (!rooms.containsKey(roomId)) {
            log.info("createRoom ing {}", roomId);
            Room room = new Room(roomId);
            rooms.put(roomId, room);

            log.info("addParticipant");
            room.addParticipant(session);
            memberRoom.put(session.getId(),room);

            CreateRoomResponse createRoomResponse = new CreateRoomResponse(SocketAction.CREATE_ROOM,roomId);
            String response = objectMapper.writeValueAsString(createRoomResponse);
            return session.send(Mono.just(session.textMessage(response)));
        } else {
            ErrorResponse errorResponse = new ErrorResponse(SocketAction.ERROR,"이미 존재하는 방입니다.");
            String response = objectMapper.writeValueAsString(errorResponse);
            return session.send(Mono.just(session.textMessage(response)));
        }
    }

    //동기적인 절차를 따라야하지 않는가
    public Mono<Void> joinRoom(JsonNode jsonNode, WebSocketSession session) throws JsonProcessingException {
        String roomId = jsonNode.get("roomId").asText();
        Room room = rooms.get(roomId);
        if (room != null) {
            room.addParticipant(session);
            memberRoom.put(session.getId(),room);
            //WebSocket 세션을 통해 메시지를 클라이언트에게 보내는 작업 수행
            //비동기적으로 실행되며, 클라이언트에게 메시지를 성공적으로 보내면 Mono<Void>를 반환

            CreateRoomResponse createRoomResponse = new CreateRoomResponse(SocketAction.JOIN_ROOM,roomId);
            String response = objectMapper.writeValueAsString(createRoomResponse);

            return session.send(Mono.just(session.textMessage(response)));
        } else {
            ErrorResponse errorResponse = new ErrorResponse(SocketAction.ERROR,"방이 존재하지 않습니다.");
            String response = objectMapper.writeValueAsString(errorResponse);
            return session.send(Mono.just(session.textMessage(response)));
        }
    }

    public Mono<Void> sendMessage(JsonNode jsonNode, WebSocketSession session) {
        Room room = memberRoom.get(session.getId());
        if(room == null) {return Mono.empty();}
        String message = jsonNode.get("message").asText();

        //메시지를 보낼때 내가 그 방에 참가 하고 있어야 보낼수 있다.
        if (room.containsMember(session)) {
            //같은 룸에 있는 사용자에게
            return room.broadcast(message);
        } else {
//            return Mono.error(new IllegalArgumentException("Room not found: " + roomId));
            return Mono.empty();
        }
    }

    public Mono<Void> deleteRoom(JsonNode jsonNode, WebSocketSession  webSocketSession) {
        return Mono.fromRunnable(() -> {
            String id = memberRoom.get(webSocketSession.getId()).getRoomId();
            rooms.remove(id);
        });
    }


    //나가기, 뒤로 버튼 누를시
    //어떤 사람이 어떤 방에있는지, 어떤 방에 어떤 사람이 있는지
    public Mono<Void> leaveRoom(WebSocketSession session) {
        return Flux
                .fromIterable(rooms.values())
                .flatMap(room -> room.removeParticipantAsync(session))
                .then(Mono.fromRunnable(()->{
                    rooms.entrySet().removeIf(entry->entry.getValue().getParticipants().isEmpty());
                }));
//        rooms.values().forEach(room -> room.removeParticipant(session));
//        rooms.entrySet().removeIf(entry -> entry.getValue().getParticipants().isEmpty());
    }
    public String createRoomNumber(){
        return UUID.randomUUID().toString();
    }
}
