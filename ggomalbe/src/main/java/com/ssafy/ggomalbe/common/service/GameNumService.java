package com.ssafy.ggomalbe.common.service;

import io.r2dbc.spi.ConnectionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.r2dbc.core.R2dbcEntityTemplate;
import org.springframework.r2dbc.core.DatabaseClient;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.reactive.TransactionalOperator;
import reactor.core.publisher.Mono;

@Service
public class GameNumService {

    private final R2dbcEntityTemplate entityTemplate;

    @Autowired
    public GameNumService(R2dbcEntityTemplate entityTemplate) {
        this.entityTemplate = entityTemplate;
    }

    @Transactional
    public Mono<Long> getIncrementGameCount() {
        return entityTemplate
                .getDatabaseClient()
                .sql("SELECT game_count FROM game_num")
                .map(row -> row.get("game_count", Long.class))
                .one()
                .flatMap(gameCount -> entityTemplate.getDatabaseClient()
                        .sql("UPDATE game_num SET game_count = game_count + 1")
                        .fetch()
                        .rowsUpdated()
                        .thenReturn(gameCount));
    }
}
