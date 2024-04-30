package com.ssafy.ggomalbe.bear.entity;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@AllArgsConstructor
public class BingoCard {
    private String letter;
    private String pronunciation;
    private String letterImgUrl;
    private String soundUrl;

    @Override
    public String toString() {
        return letter+" ";
    }
}
