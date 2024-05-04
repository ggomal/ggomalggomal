package com.ssafy.ggomalbe.bear.dto;

import com.ssafy.ggomalbe.bear.entity.SocketAction;
import com.ssafy.ggomalbe.common.entity.MemberEntity;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@AllArgsConstructor
public class GameOverResponse {
    private SocketAction action;
    private MemberEntity.Role winner;
}
