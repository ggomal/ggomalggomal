package com.ssafy.ggomalbe.common.repository;

import com.ssafy.ggomalbe.bear.dto.WordCategoryResponse;
import org.springframework.data.r2dbc.repository.Query;
import org.springframework.data.repository.reactive.ReactiveCrudRepository;
import reactor.core.publisher.Flux;

import java.util.List;

public interface WordCategoryRepository extends ReactiveCrudRepository<WordCategoryResponse, Long> {

    @Query("SELECT * FROM word WHERE syllableList = :syllableList AND initialList IN (:initialList)")
    Flux<WordCategoryResponse> findBySyllableListAndInitialListIn(Integer syllableList, List<String> initialList);
}