package com.ssafy.ggomalbe.bear.service;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.ssafy.ggomalbe.bear.dto.CreateBingoResponse;
import com.ssafy.ggomalbe.bear.dto.MarkingBingoResponse;
import com.ssafy.ggomalbe.bear.dto.WordCategoryResponse;
import com.ssafy.ggomalbe.bear.entity.BingoBoard;
import com.ssafy.ggomalbe.bear.entity.BingoPlayer;
import com.ssafy.ggomalbe.bear.entity.Room;
import com.ssafy.ggomalbe.bear.entity.SocketAction;
import com.ssafy.ggomalbe.common.entity.MemberEntity;
import com.ssafy.ggomalbe.common.service.GameNumService;
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

    private final ObjectMapper objectMapper;
    private final RoomService roomService;
    private final BingoSocketService bingoSocketService;
    private final GameNumService gameNumService;


    //todo -> 단어 칸 누르기, 다시 버튼, 통과버튼

    //=====send=====
    //다시 버튼 누르기 -> 아이창에 단어카드 모달 띄우기
    //통과버튼 누르기 -> 아이창에 해당 단어 O표시, 발음평가api결과 저장

    //게임창 만들기 -> 게임판을 만들면 아이에게도 게임판을 주고 게임시작된다
    public Mono<Void> setBingoBoard(WebSocketSession session, JsonNode jsonNode) throws JsonProcessingException {
//        String messageType = jsonNode.get("type").asText();

        log.info("parsing...");
        List<String> initialList = Arrays.asList(jsonNode.get("initial").asText().split(","));
        short syllable = Short.parseShort(jsonNode.get("syllable").asText());
        boolean finalityFlag = jsonNode.get("finalityFlag").asBoolean();

        log.info("complete");
        log.info("initialList = {}", initialList);
        log.info("syllable = {}", syllable);
        log.info("finalityFlag = {}", finalityFlag);

        WordCategoryResponse wordCategoryResponse = WordCategoryResponse.builder()
                .initialList(initialList)
                .syllable(syllable)
                .finalityFlag(finalityFlag)
                .build();

        return gameNumService.getIncrementGameCount()
                .flatMap((gameNum) -> {
                //다른 두 Mono가 작업이 완료되는 시점에 특정 동작을 하기 위한 zipWith
                    return bingoSocketService.createBingoBoard(wordCategoryResponse)
                            .zipWith(bingoSocketService.createBingoBoard(wordCategoryResponse))
                            .publishOn(Schedulers.boundedElastic())
                            .flatMap((tuple) -> {
                                BingoBoard bingoBoardT = tuple.getT1();
                                BingoBoard bingoBoardK = tuple.getT2();

                                log.info("bingoBoardK {}", bingoBoardK);
                                log.info("bingoBoardT {}", bingoBoardT);
                                Room room = roomService.findRoomByMemberId(session.getId());

                                CreateBingoResponse createBingoResponseT = new CreateBingoResponse(SocketAction.SET_BINGO_BOARD, gameNum, bingoBoardT);
                                String responseT;
                                try {
                                    responseT = objectMapper.writeValueAsString(createBingoResponseT);
                                } catch (JsonProcessingException e) {
                                    return Mono.error(e);
                                }

                                room.sendTeacherBingoBoard(responseT)
                                        .doOnSuccess(v -> {
                                            BingoPlayer bingoPlayerT = new BingoPlayer(session.getId(), session, bingoBoardT, MemberEntity.Role.TEACHER);
                                            bingoSocketService.putBingoPlayer(bingoPlayerT);
                                        })
                                        .subscribe();

                                WebSocketSession kidSocket = room.getKidSocket();

                                CreateBingoResponse createBingoResponseK = new CreateBingoResponse(SocketAction.SET_BINGO_BOARD, gameNum, bingoBoardK);
                                String responseK;
                                try {
                                    responseK = objectMapper.writeValueAsString(createBingoResponseK);
                                } catch (JsonProcessingException e) {
                                    return Mono.error(e);
                                }

                                BingoPlayer bingoPlayerK = new BingoPlayer(kidSocket.getId(), kidSocket, bingoBoardK, MemberEntity.Role.KID);
                                bingoSocketService.putBingoPlayer(bingoPlayerK);

                                return room.sendKidBingoBoard(responseK);
                            });
                });

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
    public Mono<Void> choiceBingoCardKid(WebSocketSession session, String choiceLetter) throws JsonProcessingException {
        Room room = roomService.findRoomByMemberId(session.getId());

        MarkingBingoResponse markingBingoResponse = new MarkingBingoResponse(SocketAction.FIND_LETTER, choiceLetter);
        String response = objectMapper.writeValueAsString(markingBingoResponse);
        room.sendKidRequest(response).subscribe();
        return Mono.empty();
    }


    //선생님이 선택한 카드를 아이가 선택하면 아이와 선생님에게 평가 모달을 띄운다
    //변경 -> 소켓말고 controller로 평가진행
    public Mono<Void> evaluation(WebSocketSession session, JsonNode jsonNode) throws JsonProcessingException {
        if (jsonNode.get("letter") == null) return Mono.empty();
        String choiceLetter = jsonNode.get("letter").asText();

        Room room = roomService.findRoomByMemberId(session.getId());

        //아이에게 단어카드 모달 띄워라고 요청(초기 빙고판을 보낼때 상세정보를보내기때문에 단어만 보낸다)
        MarkingBingoResponse markingBingoResponseK = new MarkingBingoResponse(SocketAction.DETAIL_BINGO_CARD, choiceLetter);
        String responseK = objectMapper.writeValueAsString(markingBingoResponseK);
        room.sendKidRequest(responseK).subscribe();

        //선생님에게 평가모달 띄워라고 요청
        MarkingBingoResponse markingBingoResponseT = new MarkingBingoResponse(SocketAction.EVALUATION, choiceLetter);
        String responseT = objectMapper.writeValueAsString(markingBingoResponseT);
        room.sendTeacherRequest(responseT).subscribe();
        return Mono.empty();
    }

    //선생님이 아이한테 음성데이터 보내라고 요청(통과버튼 선택시)
    public Mono<Void> requestVoice(WebSocketSession session, JsonNode jsonNode) throws JsonProcessingException {
        if (jsonNode.get("letter") == null) return Mono.empty();
        String choiceLetter = jsonNode.get("letter").asText();

        Room room = roomService.findRoomByMemberId(session.getId());

        MarkingBingoResponse markingBingoResponse = new MarkingBingoResponse(SocketAction.REQ_VOICE, choiceLetter);
        String response = objectMapper.writeValueAsString(markingBingoResponse);

        room.sendKidRequest(response).subscribe();

        return markingBingoCard(session, jsonNode);
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
        room.broadcastMarkBingo(response).subscribe();

        //빙고인지아닌지 -> 나의 옵션(선생,아이)을 같이보내서 우선순위
        BingoPlayer bingoPlayer = bingoSocketService.getBingoPlayer(session.getId());
        bingoSocketService.isBingo(room, bingoPlayer.getRole()).subscribe();

        return Mono.empty();
    }

//
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
