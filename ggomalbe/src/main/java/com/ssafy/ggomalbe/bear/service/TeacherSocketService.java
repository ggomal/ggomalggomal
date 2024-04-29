package com.ssafy.ggomalbe.bear.service;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.ssafy.ggomalbe.bear.entity.BingoBoard;
import com.ssafy.ggomalbe.bear.entity.BingoCard;
import com.ssafy.ggomalbe.bear.entity.BingoPlayer;
import com.ssafy.ggomalbe.bear.entity.Room;
import com.ssafy.ggomalbe.common.entity.MemberEntity;
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
        BingoBoard bingoBoardT = bingoSocketService.createBingoBoard();

        //아이빙고판도 말들어서
        BingoBoard bingoBoardK = bingoSocketService.createBingoBoard();

        //선생님이 속한 방정보를 가져온다
        Room room =roomService.findRoomByMemberId(session.getId());
        log.info("setBingo {}", room);
        //선생님에게 빙고판을 보낸다
        room.sendTeacherBingoBoard(objectMapper.writeValueAsString(bingoBoardT)).subscribe();
        BingoPlayer bingoPlayerT = new BingoPlayer(session.getId(),session,bingoBoardT, MemberEntity.Role.TEACHER);
        bingoSocketService.putBingoPlayer(bingoPlayerT);

        //아이에게 빙고판을 보낸다
        WebSocketSession kidSocket = room.getKidSocket();
        BingoPlayer bingoPlayerK = new BingoPlayer(kidSocket.getId(),kidSocket,bingoBoardK, MemberEntity.Role.KID);
        bingoSocketService.putBingoPlayer(bingoPlayerK);
        //요 윗부분 다운스트림으로 하기
        return room.sendKidBingoBoard(objectMapper.writeValueAsString(bingoBoardK));
    }

    //단어 칸 누르기 -> 아이창에 "선생님이 선택한 단어를 찾아봐"
    //선생님과 아이가 칸을 눌렀을때 반응이 다르므로 따로 처리
    public Mono<Void> choiceBingoCard(WebSocketSession session, String choiceLetter) throws JsonProcessingException {
        log.info("choiceBingoCard");
        Room room = roomService.findRoomByMemberId(session.getId());

        log.info("Bingo Room {}", room);
        //선생님이 카드를 누르면 아이에게도 반영이 되어야한다
        boolean result =  bingoSocketService.choiceBingoCard(room, choiceLetter);

        //모두에게 O를 보낸다
        room.broadcastMarkBingo(choiceLetter).subscribe();
        
        //빙고인지아닌지 -> 나의 옵션(선생,아이)을 같이보내서 우선순위
        bingoSocketService.isBingo(room);

        //빙고인지 아닌지 판단한다.
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
