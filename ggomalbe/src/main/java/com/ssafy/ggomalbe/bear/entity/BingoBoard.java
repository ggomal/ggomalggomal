package com.ssafy.ggomalbe.bear.entity;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@AllArgsConstructor
@Getter
@Setter
@ToString
public class BingoBoard {
    private BingoCard[][] board;
    private boolean[][] v;
}
