package com.ssafy.ggomalbe.bear.service;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.gson.Gson;
import com.ssafy.ggomalbe.bear.dto.CreateRoomResponse;
import com.ssafy.ggomalbe.bear.dto.ErrorResponse;
import com.ssafy.ggomalbe.bear.entity.Room;
import com.ssafy.ggomalbe.bear.entity.SocketAction;
import com.ssafy.ggomalbe.common.config.security.CustomAuthentication;
import com.ssafy.ggomalbe.common.entity.MemberEntity;
import com.ssafy.ggomalbe.member.kid.KidService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.core.context.ReactiveSecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.web.reactive.socket.WebSocketSession;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

import java.io.IOException;
import java.util.Map;
import java.util.UUID;
import java.util.concurrent.ConcurrentHashMap;

@Service
@Slf4j
@RequiredArgsConstructor
public class RoomService {
    // roomId와 Room mapping
    private static final Map<String, Room> rooms = new ConcurrentHashMap<>();

    // 세션아이디가 어떤 Room에 있는지 알기 위함(memberIdSession으로 세션을 찾아서 방을 찾는다)
    private static final Map<String, Room> memberRoom = new ConcurrentHashMap<>();

    //멤버 아이디와 세션아이디를 매핑
    private static final Map<String, WebSocketSession> memberIdSession = new ConcurrentHashMap<>();

    //해당 세션을 가지고 있는 멤버아이디 -> doFinally때 메모리에서 삭제하기위함
    private static final Map<String, String> sessionIdMember = new ConcurrentHashMap<>();

    private final KidService kidService;


    // 멤버의 아이디로 멤버가 참하고 있는 방을 return
    public Room findRoomByMemberId(String id) {
        return memberRoom.get(id);
    }

    public Mono<Void> createRoom(JsonNode jsonNode, WebSocketSession session) throws IOException {
        return ReactiveSecurityContextHolder.getContext()
                .map(securityContext -> (CustomAuthentication) securityContext.getAuthentication())
                .flatMap(authentication -> {
                    Long memberId = authentication.getDetails();
                    MemberEntity.Role memberRole = authentication.getRole();

                    //now 선생님 들고 와서 다 보내기
                    kidService.findByKidId(memberId).subscribe();

                    log.info("createRoom memberId: {}", memberId);
                    String roomId = createRoomNumber();

                    //세션아이디 -> 멤버아이디
                    //멤버아이디 -> 세션아이디
                    String memberIdStr = String.valueOf(memberId);
                    memberIdSession.put(memberIdStr, session);
                    sessionIdMember.put(session.getId(), memberIdStr);
                    log.info("create session Id : {}", session.getId());

                    if (!rooms.containsKey(roomId)) {
                        //UUID를 아이디로 가지는 room생성
                        log.info("createRoom ing {}", roomId);
                        Room room = new Room(roomId);
                        rooms.put(roomId, room);

                        //룸을 만든 사용자를 룸에 참가시킨다
                        log.info("addParticipant");
                        room.addParticipant(session, memberRole);
                        memberRoom.put(session.getId(), room);

                        //해당 세션에게 방을 만들었다고 알림
                        CreateRoomResponse createRoomResponse = new CreateRoomResponse(SocketAction.CREATE_ROOM, roomId);
//                        String response = objectMapper.writeValueAsString(createRoomResponse);
                        String response = new Gson().toJson(createRoomResponse);
                        return session.send(Mono.just(session.textMessage(response)));
                    } else {
                        ErrorResponse errorResponse = new ErrorResponse(SocketAction.ERROR, "이미 존재하는 방입니다.");
                        String response = new Gson().toJson(errorResponse);
                        return session.send(Mono.just(session.textMessage(response)));
                    }
                });
    }

    public Mono<Void> joinRoom(JsonNode jsonNode, WebSocketSession session) throws JsonProcessingException {
        return ReactiveSecurityContextHolder.getContext()
                .map(securityContext -> (CustomAuthentication) securityContext.getAuthentication())
                .flatMap(authentication -> {
                    Long memberId = authentication.getDetails();
                    MemberEntity.Role memberRole = authentication.getRole();

                    //선생님이 방에 참가하기위해서는 kidId가 session에 있어야한다.
                    //선생님이 방에 참가하기위해 아이의 아이디로 세션을 찾아온후, 세션이 참가하고있는 방의 아이디를 준다

                    if (!isExistsStr(jsonNode, "kidId")) return Mono.empty();
                    String kidId = jsonNode.get("kidId").asText();


                    //memberId와 session을 mapping
                    String memberIdStr = String.valueOf(memberId);
                    memberIdSession.put(memberIdStr, session);
                    sessionIdMember.put(session.getId(), memberIdStr);
                    log.info("joinRoom memberId: {}", memberId);

                    //kidId로 세션을 가져와서 룸을 찾는다. 
                    WebSocketSession kidSession = memberIdSession.get(kidId);
                    log.info("join session Id : {}", kidSession.getId());
                    Room room = memberRoom.get(kidSession.getId());

                    if (room != null) {
                        room.addParticipant(session, memberRole);
                        memberRoom.put(session.getId(), room);
                        //WebSocket 세션을 통해 메시지를 클라이언트에게 보내는 작업 수행
                        //비동기적으로 실행되며, 클라이언트에게 메시지를 성공적으로 보내면 Mono<Void>를 반환

                        CreateRoomResponse createRoomResponse = new CreateRoomResponse(SocketAction.JOIN_ROOM, kidId);
                        String response = new Gson().toJson(createRoomResponse);

                        return session.send(Mono.just(session.textMessage(response)));
                    } else {
                        ErrorResponse errorResponse = new ErrorResponse(SocketAction.ERROR, "방이 존재하지 않습니다.");
                        String response = new Gson().toJson(errorResponse);
//                        String response = objectMapper.writeValueAsString(errorResponse);
                        return session.send(Mono.just(session.textMessage(response)));
                    }
                });

    }

    public Mono<Void> sendMessage(JsonNode jsonNode, WebSocketSession session) {
        Room room = memberRoom.get(session.getId());
        if (room == null) {
            return Mono.empty();
        }
        if (!isExistsStr(jsonNode, "message")) return Mono.empty();
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

    public Mono<Void> deleteRoom(WebSocketSession webSocketSession) {
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
                .then(Mono.fromRunnable(() -> {
                    rooms.entrySet().removeIf(entry -> entry.getValue().getParticipants().isEmpty());
                    memberRoom.remove(session.getId());
                }));
    }

    public Mono<Void> countRoomMember(WebSocketSession session) {
        Room room = memberRoom.get(session.getId());
        if (room == null) {log.info("no Room"); return Mono.empty();}
        log.info("room member count {}",room.getParticipants().size());
        return Mono.empty();
    }

    public Mono<Void> countRoom() {
        log.info("rooms count {}", rooms.size());
        log.info("memberRoom count {}", memberRoom.size());
        return Mono.empty();
    }

    public String createRoomNumber() {
        return UUID.randomUUID().toString();
    }

    public boolean isExistsStr(JsonNode jsonNode, String str) {
        if (jsonNode.get(str) == null) {
            log.info("null {}", str);
            return false;
        }
        return true;
    }
}
