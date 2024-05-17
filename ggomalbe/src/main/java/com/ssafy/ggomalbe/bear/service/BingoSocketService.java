package com.ssafy.ggomalbe.bear.service;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.gson.Gson;
import com.ssafy.ggomalbe.bear.dto.GameOverResponse;
import com.ssafy.ggomalbe.bear.dto.WordCategoryResponse;
import com.ssafy.ggomalbe.bear.entity.*;
import com.ssafy.ggomalbe.common.entity.MemberEntity;
import com.ssafy.ggomalbe.common.repository.WordRepository;
import com.ssafy.ggomalbe.member.kid.KidService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.web.reactive.socket.WebSocketSession;
import reactor.core.publisher.Mono;

import java.util.*;
import java.util.concurrent.ConcurrentHashMap;

@Service
@Slf4j
@RequiredArgsConstructor
public class BingoSocketService {
    private static final int BINGO_LINE = 3;
    private static final short winnerCoin = 3;
    private static final short loserCoin = 1;

    private static final int LIMIT = (int) Math.pow(BINGO_LINE, 2);
    
    //sessionId를 key로 플레이어 정보 저장
    private static final Map<String, BingoPlayer> bingoPlayerMap = new ConcurrentHashMap<>();

    private final RoomService roomService;
    private final ObjectMapper objectMapper;
    private final Gson gson;

    private final WordRepository wordRepository;
    private final WordService wordService;

    private final KidService kidService;


    public void putBingoPlayer(BingoPlayer bingoPlayer) {
        bingoPlayerMap.put(bingoPlayer.getId(), bingoPlayer);
    }

    public BingoPlayer getBingoPlayer(String id) {
        return bingoPlayerMap.get(id);
    }


    //옵션에 해당하는 빙고판을 검색한다.
    public Mono<List<BingoCard>> findBingoCard(WordCategoryResponse wordCategoryResponse) {
        List<String> initialList = wordCategoryResponse.getInitialList();
        Short syllable = wordCategoryResponse.getSyllable();
        boolean finalityFlag = wordCategoryResponse.isFinalityFlag();

        Mono<List<BingoCard>> bingoCardsMono;

        if (syllable > 2) {
            log.info("create advance room");
            if (finalityFlag) {
                bingoCardsMono = wordService.getAdvancedBingoFinalityIsNotNull(wordCategoryResponse);
            } else {
                bingoCardsMono = wordService.getAdvancedBingoFinalityIsNull(wordCategoryResponse);
            }
        } else {
            log.info("create basic room");
            if (finalityFlag) {
                bingoCardsMono = wordService.getBasicBingoFinalityIsNotNull(wordCategoryResponse);
            } else {
                bingoCardsMono = wordService.getBasicBingoFinalityIsNull(wordCategoryResponse);
            }
        }

        return bingoCardsMono
                .map(bingoCards -> {
                    Collections.shuffle(bingoCards);
                    return bingoCards.subList(0, Math.min(LIMIT, bingoCards.size()));
                });
    }

    //빙고판 생성
    public BingoBoard createBingoBoard(List<BingoCard> bingoCardList) {
        log.info("createBingoBoard : {}", bingoCardList);
        Collections.shuffle(bingoCardList);
        BingoCard[][] bingoBoard = new BingoCard[BINGO_LINE][BINGO_LINE];

        int r = 0;
        for (int i = 0; i < LIMIT; i++) {
            if (i > 0 && i % BINGO_LINE == 0) r++;
            bingoBoard[r][i % BINGO_LINE] = bingoCardList.get(i);
        }
        return new BingoBoard(bingoBoard, createBingoVisitBoard());
    }

    public boolean[][] createBingoVisitBoard() {
        return new boolean[BINGO_LINE][BINGO_LINE];
    }

    //빙고카드 선택
    public boolean choiceBingoCard(Room room, String choiceLetter) {
        log.info("choiceBingoCard {} ", bingoPlayerMap.size());
        BingoPlayer bingoPlayerT = bingoPlayerMap.get(room.getTeacherSocket().getId());
        BingoPlayer bingoPlayerK = bingoPlayerMap.get(room.getKidSocket().getId());
        log.info("teacher choice bingo card {}", bingoPlayerT);
        log.info("kid choice bingo card {}", bingoPlayerK);

        boolean result1 = markBingoBoard(bingoPlayerT, choiceLetter);
        boolean result2 = markBingoBoard(bingoPlayerK, choiceLetter);

        return result1 && result2;
    }

    //선택된 빙고카드 O 표시하기 -> 이미 체크된 카드는 프론트에서 거르지만 한번더 체크
    public boolean markBingoBoard(BingoPlayer bingoPlayer, String choiceLetter) {
        log.info("markBingoBoard bingoPlayer {}", bingoPlayer);

        BingoBoard bingoBoard = bingoPlayer.getBingoBoard();
        BingoCard[][] board = bingoBoard.getBoard();

        boolean[][] v = bingoBoard.getV();

        for (int i = 0; i < BINGO_LINE; i++) {
            for (int j = 0; j < BINGO_LINE; j++) {
                String letter = board[i][j].getLetter();
                if (letter.equals(choiceLetter)) {
                    v[i][j] = true;
                    log.info("marking {} {} {}", i, j, board[i][j]);
                    return true;
                }
            }
        }

        //빙고칸에 말한 단어가 없을경우
        return false;
    }

    //빙고 유무 판단
    public Mono<Void> isBingo(Room room, MemberEntity.Role role)  {
        log.info("is Bingo room {}", room);
        WebSocketSession kidSocket = room.getKidSocket();
        WebSocketSession teacherSocket = room.getTeacherSocket();

        BingoPlayer bingoPlayerT = bingoPlayerMap.get(teacherSocket.getId());
        BingoPlayer bingoPlayerK = bingoPlayerMap.get(kidSocket.getId());

        boolean isBingoT = Bingo.isBingo(bingoPlayerT.getBingoBoard());
        boolean isBingoK = Bingo.isBingo(bingoPlayerK.getBingoBoard());
        log.info("now {} {}", role, role == MemberEntity.Role.TEACHER);
        log.info("isBingoT {}, isBingoK {} ", isBingoT, isBingoK);
        if (isBingoT && isBingoK) {
            log.info("both win");
            return gameOver(room, role);
        }

        if (isBingoT) return gameOver(room, MemberEntity.Role.TEACHER);
        if (isBingoK) return gameOver(room, MemberEntity.Role.KID);

        return Mono.empty();
    }

    public Mono<Void> gameOver(Room room, MemberEntity.Role role) {
        GameOverResponse gameOverResponse = new GameOverResponse(SocketAction.GAME_OVER, role);
        String response  = gson.toJson(gameOverResponse);
        return room.broadcastGameOver(response).then(bingoReward(room,role)).then();
    }

    public Mono<Integer> bingoReward(Room room,MemberEntity.Role role){
        Long memberId = roomService.getSessionIdMember(room.getKidSocket().getId());

        long rewardCoin = 0;
        if(role == MemberEntity.Role.KID) rewardCoin = winnerCoin;
        else rewardCoin = loserCoin;

        return kidService.addCoin(memberId, rewardCoin);
    }

    // print
    public void printBingoCard(BingoBoard bingoBoard) {
        StringBuilder sb = new StringBuilder();
        BingoCard[][] bingo = bingoBoard.getBoard();
        for (BingoCard[] bingoCards : bingo) {
            for (BingoCard bingoCard : bingoCards) {
                sb.append(bingoCard).append(" ");
            }
            sb.append("\n");
        }
        log.info("{}",sb.toString());
    }

    public Mono<Void> printBingoV(WebSocketSession session) throws JsonProcessingException {
        BingoPlayer bingoPlayer = bingoPlayerMap.get(session.getId());
        String message = objectMapper.writeValueAsString(bingoPlayer.getBingoBoard().getV());
        return session.send(Mono.just(session.textMessage(message))).then();
    }
}
