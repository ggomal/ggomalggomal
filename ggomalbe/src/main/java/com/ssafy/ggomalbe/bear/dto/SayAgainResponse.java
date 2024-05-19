package com.ssafy.ggomalbe.bear.dto;

import com.ssafy.ggomalbe.bear.entity.SocketAction;
import lombok.AllArgsConstructor;
import lombok.ToString;

@AllArgsConstructor
@ToString
public class SayAgainResponse {
    SocketAction action;
}
