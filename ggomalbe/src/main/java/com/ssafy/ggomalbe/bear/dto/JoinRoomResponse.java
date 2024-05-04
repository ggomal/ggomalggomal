package com.ssafy.ggomalbe.bear.dto;

import com.ssafy.ggomalbe.bear.entity.SocketAction;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;


@Getter
@Setter
@AllArgsConstructor
public class JoinRoomResponse {
    private SocketAction action;
    private String roomId;
}
