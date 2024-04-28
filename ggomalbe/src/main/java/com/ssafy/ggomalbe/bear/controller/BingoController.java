package com.ssafy.ggomalbe.bear.controller;

import com.ssafy.ggomalbe.bear.entity.BingoCard;
import com.ssafy.ggomalbe.bear.service.BingoSocketService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import reactor.core.publisher.Mono;

import java.time.Instant;

@RestController
@Slf4j
@RequiredArgsConstructor
@RequestMapping("/bear")
public class BingoController {
    private final BingoSocketService bingoSocketService;

    @GetMapping("/create")
    public BingoCard[][] test(){
        return bingoSocketService.createBingoBoard();
    }

    @GetMapping("/find")
    public void find(){
//        bingoSocketService.findBingoCard();
    }

    @GetMapping("/print")
    public void print(){
        BingoCard[][] bingoBoard1 = bingoSocketService.createBingoBoard();
        BingoCard[][] bingoBoard2 = bingoSocketService.createBingoBoard();

        bingoSocketService.printBingoCard(bingoBoard1);
        System.out.println();
        bingoSocketService.printBingoCard(bingoBoard2);
    }
}
