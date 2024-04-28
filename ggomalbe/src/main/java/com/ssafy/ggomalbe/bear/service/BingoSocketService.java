package com.ssafy.ggomalbe.bear.service;

import com.ssafy.ggomalbe.bear.entity.BingoCard;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

@Service
@Slf4j
public class BingoSocketService {
    private static final int BINGO_LINE = 3;
    private static final int LIMIT = (int)Math.pow(BINGO_LINE,2);

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
    public BingoCard[][] createBingoBoard(){
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
        return bingoBoard;
    }

    //빙고카드 선택
    public boolean selectBingoCard(){
        return true;
    }

    //check
    public void printBingoCard(BingoCard[][] bingo){
        for (BingoCard[] bingoCards : bingo) {
            for (BingoCard bingoCard : bingoCards) {
                System.out.print(bingoCard+" ");
            }
            System.out.println();
        }
    }

    //플로우 -> 칸을 터치하면 글자를 서버로 전송 -> 글자에 해당하는 곳 체크하고 빙고인지아닌지 판단

    //누가 이겼는지 반환

    //게임이 끝났는지 판별한다

}
