package com.ssafy.ggomalbe.bear.entity;

import lombok.*;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class BingoCard {
    private Long Id;
    private String letter;
    private String pronunciation;
    private String letterImgUrl;
    private String soundUrl;

    @Override
    public String toString() {
        return letter+" ";
    }
}
