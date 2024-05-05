package com.ssafy.ggomalbe.bear.service;

import com.ssafy.ggomalbe.bear.dto.WordCategoryRequest;
import com.ssafy.ggomalbe.bear.dto.WordCategoryResponse;
import com.ssafy.ggomalbe.bear.entity.BingoCard;
import com.ssafy.ggomalbe.common.entity.WordEntity;
import com.ssafy.ggomalbe.common.repository.WordRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.util.Pair;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

import java.util.HashSet;
import java.util.List;
import java.util.Set;

@Service
@Transactional
@RequiredArgsConstructor
public class WordService {
    private final WordRepository wordRepository;

    public Mono<WordEntity> addWord(WordEntity wordEntity) {
        return wordRepository.save(wordEntity);
    }

    public Flux<WordEntity> addWordList(Flux<WordEntity> wordEntityList) {
        return wordRepository.saveAll(wordEntityList);
    }

    public Flux<WordEntity> getWordList(){
        return wordRepository.findAll();
    }

    public Mono<WordEntity> getWord(String letter) {
        return wordRepository.findByLetter(letter);
    }

    public Mono<WordCategoryRequest> getWordCategory() {
        Flux<WordEntity> wordFlux = getWordList();
        return wordFlux
                .map(wordEntity -> Pair.of(wordEntity.getInitial(), wordEntity.getSyllable()))
                .collectList()
                .map(wordCategoryList->{
                    Set<String> initialSet = new HashSet<>();
                    Set<Short> syllableSet = new HashSet<>();
                    for (Pair<String, Short> wordCategory : wordCategoryList) {
                        initialSet.add(wordCategory.getFirst());
                        syllableSet.add(wordCategory.getSecond());
                    }
                    return new WordCategoryRequest(initialSet, syllableSet);
                });
    }

    public Mono<List<BingoCard>> getAllBingo(){
        return wordRepository.findAll()
                .map(wordEntity -> BingoCard.builder()
                        .letter(wordEntity.getLetter())
                        .pronunciation(wordEntity.getPronunciation())
                        .letterImgUrl(wordEntity.getLetterImgUrl())
                        .soundUrl(wordEntity.getSoundUrl())
                        .build())
                .collectList();
    }


    public Mono<List<BingoCard>> getBasicBingo(WordCategoryResponse wordCategoryResponse){
        return wordRepository.findByInitialInAndSyllableAndFinalityFlag(wordCategoryResponse.getInitialList(), wordCategoryResponse.getSyllable(), wordCategoryResponse.isFinalityFlag())
                .map(wordEntity -> BingoCard.builder()
                        .letter(wordEntity.getLetter())
                        .pronunciation(wordEntity.getPronunciation())
                        .letterImgUrl(wordEntity.getLetterImgUrl())
                        .soundUrl(wordEntity.getSoundUrl())
                        .build())
                .collectList();
    }

    public Mono<List<BingoCard>> getAdvancedBingo(WordCategoryResponse wordCategoryResponse){
        return wordRepository.findByInitialInAndSyllableGreaterThanEqualAndFinalityFlag(wordCategoryResponse.getInitialList(), wordCategoryResponse.getSyllable(), wordCategoryResponse.isFinalityFlag())
                .map(wordEntity -> BingoCard.builder()
                        .letter(wordEntity.getLetter())
                        .pronunciation(wordEntity.getPronunciation())
                        .letterImgUrl(wordEntity.getLetterImgUrl())
                        .soundUrl(wordEntity.getSoundUrl())
                        .build())
                .collectList();
    }


}
