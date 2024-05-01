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
import reactor.core.publisher.Mono;

import java.util.*;

@Service
@Slf4j
@RequiredArgsConstructor
public class BingoSocketService {
    private static final int BINGO_LINE = 3;
    private static final int LIMIT = (int)Math.pow(BINGO_LINE,2);
    private static final Map<String, BingoPlayer> bingoPlayerMap = new HashMap<>();

    private final RoomService roomService;
    private final ObjectMapper objectMapper;

    public void putBingoPlayer(BingoPlayer bingoPlayer) {
        bingoPlayerMap.put(bingoPlayer.getId(), bingoPlayer);
    }
    public BingoPlayer getBingoPlayer(String id) {
        return bingoPlayerMap.get(id);
    }


    //해당 룸의 선생님 빙고판


    //해당 룸의 아이 빙고판
    private List<BingoCard> findBingoCard(){
        List<BingoCard> bingoCardList = new ArrayList<>();

        bingoCardList.add(new BingoCard("산","산",null,null));
        bingoCardList.add(new BingoCard("바다","바다",null,null));
        bingoCardList.add(new BingoCard("가방","가방",null,null));
        bingoCardList.add(new BingoCard("얼음","얼음",null,null));
        bingoCardList.add(new BingoCard("고기","고기",null,null));
        bingoCardList.add(new BingoCard("포크","포크",null,null));
        bingoCardList.add(new BingoCard("엄마","엄마",null,null));
        bingoCardList.add(new BingoCard("아빠","아빠",null,null));
        bingoCardList.add(new BingoCard("삼촌","삼촌",null,null));

        return bingoCardList;
    }

    //빙고판 생성
    public BingoBoard createBingoBoard(){
        List<BingoCard> bingoCardList = findBingoCard();
        Collections.shuffle(bingoCardList);

        BingoCard[][] bingoBoard = new BingoCard[BINGO_LINE][BINGO_LINE];

        int r = 0;
        for(int i =0; i<LIMIT; i++){
            if(i>0 && i%BINGO_LINE==0){
                r++;
            }
            bingoBoard[r][i%BINGO_LINE] = bingoCardList.get(i);
        }

        return new BingoBoard(bingoBoard,createBingoVisitBoard());
    }

    //빙고카드 선택
    public boolean choiceBingoCard(Room room, String choiceLetter) {
        log.info("choiceBingoCard {} ",bingoPlayerMap.size());
        BingoPlayer bingoPlayerT = bingoPlayerMap.get(room.getTeacherSocket().getId());
        BingoPlayer bingoPlayerK = bingoPlayerMap.get(room.getKidSocket().getId());

        boolean result1= markBingoBoard(bingoPlayerT, choiceLetter);
        boolean result2= markBingoBoard(bingoPlayerK, choiceLetter);

        return result1&&result2;


        //빙고를 하고 빙고가 되었는지 판단해야한다.
    }

    //선택된 빙고카드 O 표시하기 -> 이미 체크된 카드는 프론트에서 거르지만 한번더 체크
    public boolean markBingoBoard(BingoPlayer bingoPlayer, String choiceLetter){
        log.info("markBingoBoard bingoPlayer {}", bingoPlayer);

        BingoBoard bingoBoard = bingoPlayer.getBingoBoard();
        BingoCard[][] board = bingoBoard.getBoard();

        boolean[][] v= bingoBoard.getV();

        for(int i =0; i<BINGO_LINE; i++){
            for(int j =0; j<BINGO_LINE; j++){
                String letter = board[i][j].getLetter();
                if(letter.equals(choiceLetter)){
                    v[i][j] = true;
                    log.info("marking {} {} {}",i,j,board[i][j]);
                    return true;
                }
            }
        }

        //빙고칸에 말한 단어가 없을경우
        return false;
    }

    //빙고 유무 판단
    public Mono<Void> isBingo(Room room, MemberEntity.Role role){
        log.info("is Bingo room {}", room);
        WebSocketSession kidSocket = room.getKidSocket();
        WebSocketSession teacherSocket = room.getTeacherSocket();

        BingoPlayer bingoPlayerT = bingoPlayerMap.get(teacherSocket.getId());
        BingoPlayer bingoPlayerK = bingoPlayerMap.get(kidSocket.getId());

        boolean isBingoT = Bingo.isBingo(bingoPlayerT.getBingoBoard());
        boolean isBingoK = Bingo.isBingo(bingoPlayerK.getBingoBoard());
        log.info("now {} {}", role, role==MemberEntity.Role.TEACHER);
        log.info("isBingoT {} === isBingoK {} ",isBingoT,isBingoK);
        if(isBingoT && isBingoK){
            log.info("both win");
            return gameOver(room, role);
        }

        if(isBingoT) return gameOver(room, MemberEntity.Role.TEACHER);
        if(isBingoK) return gameOver(room, MemberEntity.Role.KID);

        return Mono.empty();
    }

    public Mono<Void> gameOver(Room room, MemberEntity.Role role){
        return room.broadcastGameOver(role.toString());
    }

    public BingoCard[][] loadMyBingoBoard(){
        return null;
    }

    // print
    public void printBingoCard(BingoBoard bingoBoard){
        BingoCard[][] bingo = bingoBoard.getBoard();
        for (BingoCard[] bingoCards : bingo) {
            for (BingoCard bingoCard : bingoCards) {
                System.out.print(bingoCard+" ");
            }
            System.out.println();
        }
    }

    public boolean[][] createBingoVisitBoard(){
        return new boolean[BINGO_LINE][BINGO_LINE];
    }

    public Mono<Void> printBingoV(WebSocketSession session) throws JsonProcessingException {
        BingoPlayer bingoPlayer = bingoPlayerMap.get(session.getId());
        String message = objectMapper.writeValueAsString(bingoPlayer.getBingoBoard().getV());
        return session.send(Mono.just(session.textMessage(message))).then();
    }


    //플로우 -> 칸을 터치하면 글자를 서버로 전송 -> 글자에 해당하는 곳 체크하고 빙고인지아닌지 판단

    //누가 이겼는지 반환

    //게임이 끝났는지 판별한다

}
