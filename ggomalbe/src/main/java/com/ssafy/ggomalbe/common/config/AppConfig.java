package com.ssafy.ggomalbe.common.config;

import com.ssafy.ggomalbe.bear.handlers.Room;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import java.util.concurrent.ConcurrentHashMap;

@Configuration
public class AppConfig {

    @Bean
    public ConcurrentHashMap<String, Room> rooms() {
        return new ConcurrentHashMap<>();
    }
}