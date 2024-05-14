package com.ssafy.ggomalbe.bear.service;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.gson.Gson;
import com.ssafy.ggomalbe.bear.dto.CreateBingoResponse;
import com.ssafy.ggomalbe.bear.dto.MarkingBingoResponse;
import com.ssafy.ggomalbe.bear.dto.WordCategoryResponse;
import com.ssafy.ggomalbe.bear.entity.BingoBoard;
import com.ssafy.ggomalbe.bear.entity.BingoPlayer;
import com.ssafy.ggomalbe.bear.entity.Room;
import com.ssafy.ggomalbe.bear.entity.SocketAction;
import com.ssafy.ggomalbe.common.entity.MemberEntity;
import com.ssafy.ggomalbe.common.service.GameNumService;
import com.ssafy.ggomalbe.member.kid.KidService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.web.reactive.socket.WebSocketSession;
import reactor.core.publisher.Mono;
import reactor.core.scheduler.Schedulers;

import java.util.Arrays;
import java.util.List;

@Service
@Slf4j
@RequiredArgsConstructor
public class TeacherSocketService {

    //애가 먼저 방만들고 선생이 들어올떄
    //맵 get해서 애가 있는지 본다 -> 아이가 방

    //선생님 먼저 들어오고 애가 방만들떄
    //애가 들어오거나 나갈때 선생님에게 요청 보낸다 -> 디비에서 담당선생님을 꺼내와서 맵에 들어있는 사람만 보낸다.
    //애가 나갔다가 다시 들얼오면 joinRoom한다.  -> 이거 하는지..
    private final ObjectMapper objectMapper;
    private final Gson gson;
    private final RoomService roomService;
    private final BingoSocketService bingoSocketService;
    private final GameNumService gameNumService;

    //todo -> 단어 칸 누르기, 다시 버튼, 통과버튼

    //=====send=====
    //다시 버튼 누르기 -> 아이창에 단어카드 모달 띄우기
    //통과버튼 누르기 -> 아이창에 해당 단어 O표시, 발음평가api결과 저장

    //게임창 만들기 -> 게임판을 만들면 아이에게도 게임판을 주고 게임시작된다

    //=====receive=====
    //평가 모달띄우기

    //아이가 칸을 터치한다
    // 선생님 창에 [다시듣기 통과] 모달이 띄워진다

    //다시듣기버튼을 터치한다
    //아이 창에 모달이 다시 띄워지면서 [소리듣기 발음]진행

    //통과버튼을 터치한다
    //아이의 창에서 해당 단어 칸이 O처리가 된다.

    //선생님이 칸을 터치한다
    //아이한테 그걸 찾으라는 말이 나온다
    public Mono<Void> setBingoBoard(WebSocketSession session, JsonNode jsonNode) throws JsonProcessingException {
        //방 찾기
        Room room = roomService.findRoomByMemberId(session.getId());
        if(room == null || room.getParticipants().size() <2) {return Mono.empty();}

        //String messageType = jsonNode.get("type").asText();
        log.info("setBingoBoard parsing...");
        List<String> initialList = Arrays.asList(jsonNode.get("initial").asText().split(","));
        short syllable = Short.parseShort(jsonNode.get("syllable").asText());
        boolean finalityFlag = jsonNode.get("finalityFlag").asBoolean();

        log.info("initialList = {}", initialList);
        log.info("syllable = {}", syllable);
        log.info("finalityFlag = {}", finalityFlag);
        log.info("setBingoBoard parsing complete");

        WordCategoryResponse wordCategoryResponse = WordCategoryResponse.builder()
                .initialList(initialList)
                .syllable(syllable)
                .finalityFlag(finalityFlag)
                .build();

        return gameNumService.getIncrementGameCount()
                .flatMap(gameNum -> bingoSocketService.findBingoCard(wordCategoryResponse)
                        .flatMap(bingoCardList -> {

                            //선생님, 아이 빙고 생성
                            BingoBoard bingoBoardT = bingoSocketService.createBingoBoard(bingoCardList);
                            BingoBoard bingoBoardK = bingoSocketService.createBingoBoard(bingoCardList);

                            log.info("bingoBoardK {}", bingoBoardK);
                            log.info("bingoBoardT {}", bingoBoardT);

                            //선생님에게 보내기
                            CreateBingoResponse createBingoResponseT = new CreateBingoResponse(SocketAction.SET_BINGO_BOARD, gameNum, bingoBoardT);
                            String responseT = gson.toJson(createBingoResponseT);

                            CreateBingoResponse createBingoResponseK = new CreateBingoResponse(SocketAction.SET_BINGO_BOARD, gameNum, bingoBoardK);
                            String responseK = gson.toJson(createBingoResponseK);

                            Mono<Void> sendTeacherBoard = room.sendTeacherBingoBoard(responseT)
                                    .doOnSuccess(v -> {
                                        WebSocketSession teacherSocket = room.getTeacherSocket();
                                        log.info("setting bingoPlayer kid? {}", teacherSocket);
                                        BingoPlayer bingoPlayerT = new BingoPlayer(teacherSocket.getId(), teacherSocket, bingoBoardT, MemberEntity.Role.TEACHER);
                                        bingoSocketService.putBingoPlayer(bingoPlayerT);
                                    });


                            Mono<Void> sendKidBoard = room.sendKidBingoBoard(responseK)
                                    .doOnSuccess(v -> {
                                        //아이에게 보내기, 방에서 아이 소켓 찾기
                                        WebSocketSession kidSocket = room.getKidSocket();
                                        log.info("setting bingoPlayer kid? {}", kidSocket);
                                        BingoPlayer bingoPlayerK = new BingoPlayer(kidSocket.getId(), kidSocket, bingoBoardK, MemberEntity.Role.KID);
                                        bingoSocketService.putBingoPlayer(bingoPlayerK);
                                    });
                            return Mono.when(sendTeacherBoard,sendKidBoard);
                        })
                );
    }


    public Mono<Void> play(WebSocketSession session, JsonNode jsonNode) throws JsonProcessingException {
        if (jsonNode.get("letter") == null) return Mono.empty();
        String choiceLetter = jsonNode.get("letter").asText();
        Room room = roomService.findRoomByMemberId(session.getId());

        //아이 일 경우 바로 평가모드
        if (session.getId().equals(room.getKidSocket().getId())) {
            return evaluation(session, jsonNode);
        }

        //선생님일 경우 선택 모드
        if (session.getId().equals(room.getTeacherSocket().getId())) {
            return choiceBingoCardKid(session, choiceLetter);
        }

        return Mono.empty();
    }

    //선생님이 빙고카드를 선택하면 아이에게 찾으라고 보낸다
    public Mono<Void> choiceBingoCardKid(WebSocketSession session, String choiceLetter){
        Room room = roomService.findRoomByMemberId(session.getId());

        MarkingBingoResponse markingBingoResponse = new MarkingBingoResponse(SocketAction.FIND_LETTER, choiceLetter);
//        String response = objectMapper.writeValueAsString(markingBingoResponse);
        String response = gson.toJson(markingBingoResponse);
        return room.sendKidRequest(response).then();
    }


    //선생님이 선택한 카드를 아이가 선택하면 아이와 선생님에게 평가 모달을 띄운다
    //변경 -> 소켓말고 controller로 평가진행
    public Mono<Void> evaluation(WebSocketSession session, JsonNode jsonNode) {
        // JSON 노드에서 'letter' 필드가 없으면 빈 Mono를 반환
        if (jsonNode.get("letter") == null) return Mono.empty();
        String choiceLetter = jsonNode.get("letter").asText();

        Room room = roomService.findRoomByMemberId(session.getId());

        //아이에게 단어카드 모달 띄워라고 요청(초기 빙고판을 보낼때 상세정보를보내기때문에 단어만 보낸다)
        MarkingBingoResponse markingBingoResponseK = new MarkingBingoResponse(SocketAction.DETAIL_BINGO_CARD, choiceLetter);
        String responseK = gson.toJson(markingBingoResponseK);

        Mono<Void> kidRequestMono = room.sendKidRequest(responseK);

        //선생님에게 평가모달 띄워라고 요청
        MarkingBingoResponse markingBingoResponseT = new MarkingBingoResponse(SocketAction.EVALUATION, choiceLetter);
        String responseT = gson.toJson(markingBingoResponseT);

        Mono<Void> teacherRequestMono = room.sendTeacherRequest(responseT);
        return Mono.when(kidRequestMono,teacherRequestMono);
    }

    //선생님이 아이한테 음성데이터 보내라고 요청(통과버튼 선택시)
    public Mono<Void> requestVoice(WebSocketSession session, JsonNode jsonNode) throws JsonProcessingException {
        if (jsonNode.get("letter") == null) return Mono.empty();
        String choiceLetter = jsonNode.get("letter").asText();

        Room room = roomService.findRoomByMemberId(session.getId());

        MarkingBingoResponse markingBingoResponse = new MarkingBingoResponse(SocketAction.REQ_VOICE, choiceLetter);
        String response = objectMapper.writeValueAsString(markingBingoResponse);

        Mono<Void> sendKidRequestMono = room.sendKidRequest(response);

        return markingBingoCard(session, jsonNode).then(sendKidRequestMono);
    }

    // 선생님이 O를 눌렀을때(아이의 발음을 api로 평가하고, 둘다 O표시를 하고, 빙고인지 판단하고 맞다면 게임종료)
    // 아이가 말한 단어를 통과했을때 빙고보드에 표시하고 빙고인지 판단하고 true이면 게임을끝낸다.
    public Mono<Void> markingBingoCard(WebSocketSession session, JsonNode jsonNode) throws JsonProcessingException {
        if (jsonNode.get("letter") == null) return Mono.empty();
        String choiceLetter = jsonNode.get("letter").asText();

        //통과버튼 눌렀을때 데이터베이스에 저장, api 발음평가 점수 가져오기

        log.info("choiceBingoCard");
        Room room = roomService.findRoomByMemberId(session.getId());

        log.info("Bingo Room {}", room);
        //선생님이 카드를 누르면 아이에게도 반영이 되어야한다
        boolean result = bingoSocketService.choiceBingoCard(room, choiceLetter);

        //모두에게 O를 보낸다
        MarkingBingoResponse markingBingoResponse = new MarkingBingoResponse(SocketAction.MARKING_BINGO, choiceLetter);
        String response = objectMapper.writeValueAsString(markingBingoResponse);
        Mono<Void> boardcastMarkingBingoMono = room.broadcastMarkBingo(response);

        //빙고인지아닌지 -> 나의 옵션(선생,아이)을 같이보내서 우선순위
        BingoPlayer bingoPlayer = bingoSocketService.getBingoPlayer(session.getId());
        Mono<Void> bingoMono = bingoSocketService.isBingo(room, bingoPlayer.getRole());

        return Mono.when(boardcastMarkingBingoMono,bingoMono);
    }
}
