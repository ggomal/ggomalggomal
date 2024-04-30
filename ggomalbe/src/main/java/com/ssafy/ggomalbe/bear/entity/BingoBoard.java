package com.ssafy.ggomalbe.bear.entity;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;

@AllArgsConstructor
@Getter
@Setter
public class BingoBoard {
    private BingoCard[][] board;
    private boolean[][] v;
}
