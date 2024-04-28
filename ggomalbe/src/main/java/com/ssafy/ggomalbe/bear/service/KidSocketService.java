package com.ssafy.ggomalbe.bear.service;

import com.ssafy.ggomalbe.bear.entity.BingoPlayer;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.Map;

@Service
@Slf4j
@RequiredArgsConstructor
public class KidSocketService {
    //todo -> 단어 칸 누르기,
    private final RoomService roomService;
    private static final Map<String, BingoPlayer> KidBingoPlayerMap = new HashMap<>();



    //=====send=====
    //단어 칸 누르기 -> 선생님창에 평가모달띄우기
    //같은단어칸 누르기 -> 맞으면 아이모달띄우고 선생님은 평가모달, 아니면 "다시골라"(선생님이 누르면 누른 단어를 같이 보내고 맞는걸 누를때까지 반복, 칼d
    //그럼 아이차례단어누르기랑 선생님이단어누르기 따로
    // 아이차례->아무거나 선택가능
    // 선생님차례->선생님이 선택한거랑 같은거



    //말하기 -> 선생님이 O를 누르면 해당칸 O, 선생님이 X누르면 다시 단어카드띄우기




    //=====receive=====
    //선생님이 O누르기 -> 아이 빙고에 O
    //선생님이 X누르기 -> 단어카드모달다시



    //아이가 칸을 터치한다
    //모달창이 뜬다

    //선생님이 칸을 터치한다
    //아이가 같은 칸을 터치한다.

    //선생님이 다시듣기 버튼을 누른다

    //선생님이 통과버튼을 누른다
    //발음평가 api 호출후 데이터 베이스에 저장,





}
