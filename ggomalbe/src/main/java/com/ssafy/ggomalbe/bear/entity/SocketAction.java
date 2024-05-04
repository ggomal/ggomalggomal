package com.ssafy.ggomalbe.bear.entity;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.RequiredArgsConstructor;

@AllArgsConstructor
@Getter
public enum SocketAction {
    MARKING_BINGO("marking"), EVALUATION("evaluation teacher"),
    SET_BINGO_BOARD("set bingo board"), DETAIL_BINGO_CARD("detail bingo card"),
    CREATE_ROOM("create room"), JOIN_ROOM("join room"), ERROR("error"),
    FIND_LETTER("kid find bingo card"),
    GAME_OVER("game over"), REQ_VOICE("request voice");

    private final String description;
}

