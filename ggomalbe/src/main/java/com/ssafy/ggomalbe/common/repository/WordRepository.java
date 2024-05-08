package com.ssafy.ggomalbe.common.repository;

import com.ssafy.ggomalbe.bear.dto.WordCategoryResponse;
import com.ssafy.ggomalbe.common.entity.WordEntity;
import org.springframework.data.domain.Example;
import org.springframework.data.r2dbc.repository.Query;
import org.springframework.data.r2dbc.repository.R2dbcRepository;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

import java.util.Iterator;
import java.util.List;

public interface WordRepository extends R2dbcRepository<WordEntity,Long> {
    Mono<WordEntity> findByLetter(String letter);

    // ** finalityFlag -> finality
//    @Query("SELECT * FROM word WHERE syllable = :syllable AND finality_flag= :finalityFlag AND initial IN (:initialList)")
//    Flux<WordEntity> findByInitialInAndSyllableAndFinalityFlag(List<String> initialList, Short syllable, boolean finalityFlag);
//
//    @Query("SELECT * FROM word WHERE syllable >= :syllable AND finality_flag= :finalityFlag AND initial IN (:initialList)")
//    Flux<WordEntity> findByInitialInAndSyllableGreaterThanEqualAndFinalityFlag(List<String> initialList, Short syllable, boolean finalityFlag);

    @Query("SELECT * FROM word WHERE syllable = :syllable AND initial IN (:initialList) AND finality IS NULL")
    Flux<WordEntity> findByInitialInAndSyllableAndFinalityIsNull(List<String> initialList, Short syllable);

    @Query("SELECT * FROM word WHERE syllable = :syllable AND initial IN (:initialList) AND finality IS NOT NULL")
    Flux<WordEntity> findByInitialInAndSyllableAndFinalityIsNotNull(List<String> initialList, Short syllable);

    @Query("SELECT * FROM word WHERE syllable > :syllable AND initial IN (:initialList) AND finality IS NULL")
    Flux<WordEntity> findByInitialInAndSyllableGreaterThanEqualAndFinalityIsNull(List<String> initialList, Short syllable);

    @Query("SELECT * FROM word WHERE syllable > :syllable AND initial IN (:initialList) AND finality IS NOT NULL")
    Flux<WordEntity> findByInitialInAndSyllableGreaterThanEqualAndFinalityIsNotNull(List<String> initialList, Short syllable);



    @Query("update word set sound_url = :soundUrl where letter = :letter and sound_url = '';")
    Flux<WordEntity> updateSoundUrlByLetter(String letter, String soundUrl);

}


