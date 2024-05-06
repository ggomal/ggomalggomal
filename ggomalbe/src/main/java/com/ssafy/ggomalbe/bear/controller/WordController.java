package com.ssafy.ggomalbe.bear.controller;

import com.ssafy.ggomalbe.bear.dto.WordCategoryRequest;
import com.ssafy.ggomalbe.bear.dto.WordCategoryResponse;
import com.ssafy.ggomalbe.bear.dto.WordRequest;
import com.ssafy.ggomalbe.bear.entity.BingoCard;
import com.ssafy.ggomalbe.bear.service.WordServiceImpl;
import com.ssafy.ggomalbe.common.entity.WordEntity;
import com.ssafy.ggomalbe.common.repository.WordCategoryRepository;
import com.ssafy.ggomalbe.common.repository.WordRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

import java.util.ArrayList;
import java.util.List;

@RestController
@RequestMapping("/word")
@Slf4j
@RequiredArgsConstructor
public class WordController {
    
    private final WordServiceImpl wordService;
    private final WordRepository wordRepository;
    private final WordCategoryRepository wordCategoryRepository;

    @GetMapping("/condition")
    public Flux<WordEntity> findConditionWord() {
        WordCategoryResponse wordCategoryResponse =new WordCategoryResponse();
        List<String> initialList =new ArrayList<>();
        initialList.add("ㄸ");
        Short syllable = 2;
        boolean finalityFlag = true;
        return wordRepository.findByInitialInAndSyllableAndFinalityFlag(initialList, syllable, finalityFlag);
    }

    @GetMapping("/condition2")
    public Flux<WordEntity> findConditionWord2() {
        WordCategoryResponse wordCategoryResponse =new WordCategoryResponse();
        List<String> initialList =new ArrayList<>();
        initialList.add("ㅆ");
        Short syllable = 3;
        boolean finalityFlag = true;
        return wordRepository.findByInitialInAndSyllableGreaterThanEqualAndFinalityFlag(initialList, syllable, finalityFlag);
    }

    @GetMapping("/category")
    public Mono<WordCategoryRequest> getInitial() {
        return wordService.getWordCategory();
    }

    @GetMapping("/bingo")
    public Mono<List<BingoCard>> getBingo() {
        List<String> initialList =new ArrayList<>();
        initialList.add("ㄸ");
        Short syllable = 2;
        boolean finalityFlag = true;

        WordCategoryResponse wordCategoryResponse = WordCategoryResponse.builder()
                .syllable(syllable)
                .finalityFlag(finalityFlag)
                .initialList(initialList)
                .build();

        return wordService.getBasicBingo(wordCategoryResponse);
    }

    @GetMapping("/bingo2")
    public Mono<List<BingoCard>> getBingo2() {
        List<String> initialList =new ArrayList<>();
        initialList.add("ㅆ");
        Short syllable = 3;
        boolean finalityFlag = true;

        WordCategoryResponse wordCategoryResponse = WordCategoryResponse.builder()
                .syllable(syllable)
                .finalityFlag(finalityFlag)
                .initialList(initialList)
                .build();

        return wordService.getAdvancedBingo(wordCategoryResponse);
    }

    @GetMapping
    public Mono<WordEntity> findOne(@RequestParam("letter") String letter) {
        log.info("findOne");
        return wordService.getWord(letter);
    }

    @GetMapping("/all")
    public Flux<WordEntity> findAll() {
        log.info("findAll");
        return wordService.getWordList();
    }

    @GetMapping("/word")
    public Flux<WordEntity> categoryAll() {
        log.info("categoryAll");
        return wordService.getWordList();
    }

    @PostMapping
    public Mono<WordEntity> save(@RequestBody WordRequest wordRequest) {
        WordEntity wordEntity = convertToEntity(wordRequest);
        log.info("save {}", wordEntity);
        return wordService.addWord(wordEntity);
    }

    @PostMapping("/all")
    public Flux<WordEntity> saveAll(@RequestBody List<WordRequest> wordRequest) {
        log.info("size {}", wordRequest.size());
        List<WordEntity> wordEntityList = new ArrayList<>();
        for (WordRequest request : wordRequest) {
            wordEntityList.add(convertToEntity(request));
        }

        return wordService.addWordList(Flux.fromIterable(wordEntityList));
    }


    // WordRequest를 WordEntity로 변환하는 메소드
    private WordEntity convertToEntity(WordRequest wordRequest) {
        if (wordRequest.getSoundUrl() == null) {wordRequest.setSoundUrl("");}
        if (wordRequest.getLetterImgUrl() == null) {wordRequest.setLetterImgUrl("");}
        return WordEntity.builder()
                .letter(wordRequest.getLetter())
                .pronunciation(wordRequest.getPronunciation())
                .letterImgUrl(wordRequest.getLetterImgUrl())
                .soundUrl(wordRequest.getSoundUrl())
                .initial(wordRequest.getInitial())
                .syllable(wordRequest.getSyllable())
                .finalityFlag(wordRequest.getFinalityFlag())
                .build();
    }
}
