package com.ssafy.ggomalbe.bear.service;

import com.ssafy.ggomalbe.bear.dto.LetterSoundRequest;
import com.ssafy.ggomalbe.bear.dto.WordCategoryRequest;
import com.ssafy.ggomalbe.bear.dto.WordCategoryResponse;
import com.ssafy.ggomalbe.bear.entity.BingoCard;
import com.ssafy.ggomalbe.common.entity.WordEntity;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

import java.util.List;

public interface WordService {
    Mono<WordEntity> addWord(WordEntity wordEntity);

    Flux<WordEntity> addWordList(Flux<WordEntity> wordEntityList);

    Flux<WordEntity> getWordList();

    Mono<WordEntity> getWord(String letter);

    Mono<WordCategoryRequest> getWordCategory();

    Mono<List<BingoCard>> getBasicBingoFinalityIsNotNull(WordCategoryResponse wordCategoryResponse);

    Mono<List<BingoCard>> getBasicBingoFinalityIsNull(WordCategoryResponse wordCategoryResponse);

    Mono<List<BingoCard>> getAdvancedBingoFinalityIsNotNull(WordCategoryResponse wordCategoryResponse);

    Mono<List<BingoCard>> getAdvancedBingoFinalityIsNull(WordCategoryResponse wordCategoryResponse);

    Flux<WordEntity> updateSoundUrlByLetter(List<LetterSoundRequest> letterSoundList);
}
