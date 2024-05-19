package com.ssafy.ggomalbe.bear.dto;

import com.ssafy.ggomalbe.bear.entity.SocketAction;
import lombok.*;
import org.reactivestreams.Publisher;

@Getter
@Setter
@AllArgsConstructor
@RequiredArgsConstructor
@Builder
public class KidOnlineDto {
    private SocketAction action;
    private Long kidId;
    private boolean isOnline;
}
