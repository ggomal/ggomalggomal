package com.ssafy.ggomalbe.bear.dto;

import com.ssafy.ggomalbe.bear.entity.BingoBoard;
import com.ssafy.ggomalbe.bear.entity.SocketAction;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@AllArgsConstructor
public class CreateBingoResponse {
    private SocketAction action;
    private Long gameNum;
    private BingoBoard bingoBoard;
}
