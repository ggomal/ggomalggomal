package com.ssafy.ggomalbe.common.config;

import io.asyncer.r2dbc.mysql.MySqlConnectionConfiguration;
import io.asyncer.r2dbc.mysql.MySqlConnectionFactory;
import io.asyncer.r2dbc.mysql.MySqlConnectionFactoryProvider;
import io.r2dbc.spi.ConnectionFactory;
import org.springframework.boot.autoconfigure.r2dbc.ConnectionFactoryOptionsBuilderCustomizer;
import org.springframework.boot.autoconfigure.r2dbc.R2dbcAutoConfiguration;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.r2dbc.config.AbstractR2dbcConfiguration;
import org.springframework.data.r2dbc.config.EnableR2dbcAuditing;

import java.time.Duration;
import java.time.ZoneId;

@EnableR2dbcAuditing
@Configuration
public class R2dbcConfig extends R2dbcAutoConfiguration {
    @Bean
    public ConnectionFactoryOptionsBuilderCustomizer mysqlCustomizer() {
        return (builder) ->
        builder.option(MySqlConnectionFactoryProvider.SERVER_ZONE_ID, ZoneId.of(
           "UTC"));
    }
}
