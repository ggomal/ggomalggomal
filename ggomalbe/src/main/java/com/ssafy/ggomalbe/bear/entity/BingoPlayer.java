package com.ssafy.ggomalbe.bear.entity;

import com.ssafy.ggomalbe.common.entity.MemberEntity;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import lombok.Setter;
import org.springframework.web.reactive.socket.WebSocketSession;

@AllArgsConstructor
@Getter
@Setter
public class BingoPlayer {
    private String id;
    private WebSocketSession session;
    private BingoBoard bingoBoard;
    private MemberEntity.Role role;

}
