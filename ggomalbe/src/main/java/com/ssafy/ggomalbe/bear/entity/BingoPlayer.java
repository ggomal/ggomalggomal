package com.ssafy.ggomalbe.bear.entity;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;
import org.springframework.web.reactive.socket.WebSocketSession;

@AllArgsConstructor
@Getter
@Setter
public class BingoPlayer {
    private String id;
    private WebSocketSession session;
    private BingoCard[][] board;
    private boolean[][] v;
}
