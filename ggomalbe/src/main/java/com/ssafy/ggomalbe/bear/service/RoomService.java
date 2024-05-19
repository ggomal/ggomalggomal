package com.ssafy.ggomalbe.bear.service;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonNode;
import com.google.gson.Gson;
import com.ssafy.ggomalbe.bear.dto.CreateRoomResponse;
import com.ssafy.ggomalbe.bear.dto.ErrorResponse;
import com.ssafy.ggomalbe.bear.dto.KidOnlineDto;
import com.ssafy.ggomalbe.bear.entity.Room;
import com.ssafy.ggomalbe.bear.entity.SocketAction;
import com.ssafy.ggomalbe.common.entity.MemberEntity;
import com.ssafy.ggomalbe.member.kid.KidService;
import com.ssafy.ggomalbe.member.kid.dto.MemberIdRoleDto;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
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
    private static final Map<Long, WebSocketSession> memberIdSession = new ConcurrentHashMap<>();

    //해당 세션을 가지고 있는 멤버아이디 -> doFinally때 메모리에서 삭제하기위함
    private static final Map<String, Long> sessionIdMember = new ConcurrentHashMap<>();

    private final KidService kidService;

    private final Gson gson;

    public void initSessionMember(WebSocketSession session, MemberIdRoleDto memberIdRoleDto){
        memberIdSession.put(memberIdRoleDto.getMemberId(), session);
        sessionIdMember.put(session.getId(), memberIdRoleDto.getMemberId());
    }

    // 멤버의 아이디로 멤버가 참하고 있는 방을 return
    public Room findRoomByMemberId(String id) {
        return memberRoom.get(id);
    }

    public Long getSessionIdMember (String sessionId) {
        return sessionIdMember.get(sessionId);
    }


    public Mono<Void> createRoom(JsonNode jsonNode, WebSocketSession session, MemberIdRoleDto memberIdRoleDto) {
        Long memberId = memberIdRoleDto.getMemberId();
        MemberEntity.Role memberRole = memberIdRoleDto.getMemberRole();

        log.info("createRoom memberId: {}", memberId);
        String roomId = createRoomNumber();

        //세션아이디 -> 멤버아이디
        //멤버아이디 -> 세션아이디
        String memberIdStr = String.valueOf(memberId);
        memberIdSession.put(memberId, session);
        sessionIdMember.put(session.getId(), memberId);
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
            String response = gson.toJson(createRoomResponse);
            return Mono.when(session.send(Mono.just(session.textMessage(response))), changeStatus(memberIdRoleDto, true));
        } else {
            ErrorResponse errorResponse = new ErrorResponse(SocketAction.ERROR, "이미 존재하는 방입니다.");
            String response = new Gson().toJson(errorResponse);
            return session.send(Mono.just(session.textMessage(response)));
        }
    }

    public Mono<Void> joinRoom(JsonNode jsonNode, WebSocketSession session , MemberIdRoleDto memberIdRoleDto) {
        Long memberId = memberIdRoleDto.getMemberId();
        MemberEntity.Role memberRole = memberIdRoleDto.getMemberRole();

        //선생님이 방에 참가하기위해서는 kidId가 session에 있어야한다.
        //선생님이 방에 참가하기위해 아이의 아이디로 세션을 찾아온후, 세션이 참가하고있는 방의 아이디를 준다

        if (!isExistsStr(jsonNode, "kidId")) return Mono.empty();
        Long kidId = Long.parseLong(jsonNode.get("kidId").asText());

        //memberId와 session을 mapping
        String memberIdStr = String.valueOf(memberId);
        memberIdSession.put(memberId, session);
        sessionIdMember.put(session.getId(), memberId);
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
            CreateRoomResponse createRoomResponse = new CreateRoomResponse(SocketAction.JOIN_ROOM, String.valueOf(kidId));
            String response = gson.toJson(createRoomResponse);

            return Mono.when(session.send(Mono.just(session.textMessage(response))), changeStatus(memberIdRoleDto, true));
        } else {
            ErrorResponse errorResponse = new ErrorResponse(SocketAction.ERROR, "방이 존재하지 않습니다.");
            String response = gson.toJson(errorResponse);
            return session.send(Mono.just(session.textMessage(response)));
        }
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
            //return Mono.error(new IllegalArgumentException("Room not found: " + roomId));
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
    public Mono<Void> leaveRoom(WebSocketSession session, MemberIdRoleDto memberIdRoleDto) {
        return Flux
                .fromIterable(rooms.values())
                .flatMap(room -> room.removeParticipantAsync(session))
                .then(changeStatus(memberIdRoleDto,false))
                .then(Mono.fromRunnable(() -> {
                    //참가자 없는 방 삭제
                    rooms.entrySet().removeIf(entry -> entry.getValue().getParticipants().isEmpty());
                    
                    //나간 사용자 아이디 가져오기
                    Long id = sessionIdMember.get(session.getId());

                    //세션아이디로 아이디 매핑정보 삭제
                    sessionIdMember.remove(session.getId());
                    
                    //멤버 아이디로 세션매핑정보 삭제
                    memberIdSession.remove(id);

                    //세션아이디와 룸정보 매핑정보 삭제
                    memberRoom.remove(session.getId());
                }));
    }

    public Mono<Void> countRoomMember(WebSocketSession session) {
        Room room = memberRoom.get(session.getId());
        if (room == null) {
            log.info("no Room");
            return Mono.empty();
        }
        log.info("room member count {}", room.getParticipants().size());
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

    //선생님이 connection할때 아이의 정보가 있는지 확인해서 온라인 여부를 판별한다
    public Mono<Void> isOnlineKidId(WebSocketSession session, JsonNode jsonNode) {
        if (!isExistsStr(jsonNode, "kidId")) return Mono.empty();
        Long id = Long.parseLong(jsonNode.get("kidId").asText());

        return Flux.fromIterable(memberIdSession.keySet())
                .filter(findId -> findId.longValue() == id.longValue())
                .next()
                .map(result -> KidOnlineDto.builder().action(SocketAction.KID_ONLINE).kidId(id).isOnline(true).build())
                .switchIfEmpty(Mono.just(KidOnlineDto.builder().action(SocketAction.KID_ONLINE).kidId(id).isOnline(false).build()))
                .map(kidOnlineDto -> gson.toJson(kidOnlineDto))
                .flatMap(result -> session.send(Mono.just(session.textMessage(result))));
    }

    //아이가 createRoom, joinRoom, leaveRoom할때 선생님이 들어와 있으면 온라인 여부를 보낸다.:
    //switchIfEmpty: Mono나 Flux가 비어있을 때 새로운 Mono나 Flux로 교체합니다.
    //ex) .switchIfEmpty(Mono.error(new NotFoundException("Data not found")));

    //defaultIfEmpty: Mono나 Flux가 비어있을 때 기본 값을 반환합니다.
    //ex) .defaultIfEmpty(new Data()); // 기본값은 비어있는 경우에만 반환됨

    public Mono<Void> changeStatus(MemberIdRoleDto memberIdRoleDto, boolean status) {
        Long kidId= memberIdRoleDto.getMemberId();
        MemberEntity.Role memberRole = memberIdRoleDto.getMemberRole();
        if(memberRole != MemberEntity.Role.KID) return Mono.empty();

        return kidService.findByKidId(kidId)
                .doOnNext(n->log.info("changeStatus n {}", n))
                .flatMap(kid -> {
                    WebSocketSession session = memberIdSession.get(kid.getTeacherId());
                    if(session == null){
                        return Mono.empty();
                    }else{
                        return Mono.just(session);
                    }
                })
                .flatMap(session -> {
                    KidOnlineDto kidOnlineDto = KidOnlineDto.builder().action(SocketAction.KID_ONLINE).kidId(kidId).isOnline(status).build();
                    String kidOnlineDtoStr = gson.toJson(kidOnlineDto);
                    return session.send(Mono.just(session.textMessage(kidOnlineDtoStr)));
                }).then();
    }
}
