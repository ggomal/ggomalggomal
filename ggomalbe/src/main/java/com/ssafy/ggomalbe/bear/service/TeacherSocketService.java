package com.ssafy.ggomalbe.bear.service;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.ssafy.ggomalbe.bear.entity.BingoCard;
import com.ssafy.ggomalbe.bear.entity.BingoPlayer;
import com.ssafy.ggomalbe.bear.entity.Room;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.web.reactive.socket.WebSocketSession;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

import java.util.HashMap;
import java.util.Map;

@Service
@Slf4j
@RequiredArgsConstructor
public class TeacherSocketService {

    private final ObjectMapper objectMapper;
    private final RoomService roomService;
    private final BingoSocketService bingoSocketService;


    //todo -> 단어 칸 누르기, 다시 버튼, 통과버튼

    //=====send=====
    //다시 버튼 누르기 -> 아이창에 단어카드 모달 띄우기
    //통과버튼 누르기 -> 아이창에 해당 단어 O표시, 발음평가api결과 저장

    //게임창 만들기 -> 게임판을 만들면 아이에게도 게임판을 주고 게임시작된다
    public Mono<Void> setBingoBoard(WebSocketSession session) throws JsonProcessingException {

        //빙고판을 만들고
        BingoCard[][] teacherBingoBoard = bingoSocketService.createBingoBoard();

        //아이빙고판도 말들어서
        BingoCard[][] kidBingoBoard = bingoSocketService.createBingoBoard();

        //선생님이 속한 방정보를 가져온다
        String roomId = roomService.memberRoomId(session.getId());
        Room room = roomService.getRoom(roomId);


        //선생님에게 빙고판을 보낸다
        room.sendTeacherBingoBoard(objectMapper.writeValueAsString(teacherBingoBoard)).subscribe();
        BingoPlayer bingoPlayerT = new BingoPlayer(session.getId(),session,teacherBingoBoard, bingoSocketService.createBingoVisitBoard());
        bingoSocketService.putTeacherBingoPlayer(bingoPlayerT);

        //아이에게 빙고판을 보낸다
        WebSocketSession kidSocket = room.getKidSocket();
        BingoPlayer bingoPlayerK = new BingoPlayer(kidSocket.getId(),kidSocket,kidBingoBoard, bingoSocketService.createBingoVisitBoard());
        bingoSocketService.putKidBingoPlayerMap(bingoPlayerK);
        //요 윗부분 다운스트림으로 하기
        return room.sendKidBingoBoard(objectMapper.writeValueAsString(kidBingoBoard));

    }

    //단어 칸 누르기 -> 아이창에 "선생님이 선택한 단어를 찾아봐"
    public Mono<Void> choiceBingoCard(WebSocketSession session, String choiceLetter) throws JsonProcessingException {
        bingoSocketService.choiceBingoCard(session,choiceLetter);
        return Mono.empty();
    }

    //=====receive=====
    //평가 모달띄우기
    //

    //아이가 칸을 터치한다
    // 선생님 창에 [다시듣기 통과] 모달이 띄워진다

    //다시듣기버튼을 터치한다
    //아이 창에 모달이 다시 띄워지면서 [소리듣기 발음]진행

    //통과버튼을 터치한다
    //아이의 창에서 해당 단어 칸이 O처리가 된다.

    //선생님이 칸을 터치한다
    //아이한테 그걸 찾으라는 말이 나온다


}
