package com.ssafy.ggomalbe.bear.entity;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.RequiredArgsConstructor;

@AllArgsConstructor
@Getter
public enum SocketAction {
    MARKING("marking"), EVALUATION_TEACHER("evaluation teacher"),
    EVALUATION_KID("evaluation kid"), REQ_FIND("kid find bingo card"),
    GAME_OVER("game over"), REQ_VOICE("request voice")
    ;

    private final String description;
}

