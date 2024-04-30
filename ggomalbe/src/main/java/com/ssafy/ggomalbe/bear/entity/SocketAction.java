package com.ssafy.ggomalbe.bear.entity;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.RequiredArgsConstructor;

@AllArgsConstructor
@Getter
public enum SocketAction {
    MARKING("bingo mark");

    private final String description;
}
