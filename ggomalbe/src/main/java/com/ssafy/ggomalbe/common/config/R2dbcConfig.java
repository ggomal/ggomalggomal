package com.ssafy.ggomalbe.common.config;

import io.asyncer.r2dbc.mysql.MySqlConnectionConfiguration;
import io.asyncer.r2dbc.mysql.MySqlConnectionFactory;
import io.r2dbc.spi.ConnectionFactory;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.r2dbc.config.AbstractR2dbcConfiguration;
import org.springframework.data.r2dbc.config.EnableR2dbcAuditing;

import java.time.Duration;
import java.time.ZoneId;

@EnableR2dbcAuditing
@Configuration
public class R2dbcConfig extends AbstractR2dbcConfiguration {
    @Bean
    @Override
    public ConnectionFactory connectionFactory() {
        return MySqlConnectionFactory.from(
                MySqlConnectionConfiguration.builder()
                        .host("127.0.0.1")
                        .port(3306)
                        .username("root")
                        .password("1234")
                        .database("ggomal")
                        .serverZoneId(ZoneId.of("UTC"))
                        .connectTimeout(Duration.ofSeconds(3))
                        .useServerPrepareStatement()
                        .build()
        );
    }
}
