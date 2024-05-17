package com.ssafy.ggomalbe.bear.service;

import com.ssafy.ggomalbe.bear.entity.Chat;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Sinks;

import java.util.Collection;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

@Slf4j
@Service
public class ChatService {
    private static final Map<String, Sinks.Many<Chat>> chatSinkMap
            = new ConcurrentHashMap<>();

    public Collection<Sinks.Many<Chat>> getAllSinks(){
        return chatSinkMap.values();
    }

    public Flux<Chat> register(String iam) {
        Sinks.Many<Chat> sink = Sinks.many().unicast().onBackpressureBuffer();

        chatSinkMap.put(iam, sink);
        return sink.asFlux();
    }

    public boolean sendChat(String iam, Chat chat) {
//        log.info("iam: {}, chat: {}", iam, chat);
        Sinks.Many<Chat> sink = chatSinkMap.get(iam);
        if (sink == null){
            return false;
        }

        sink.tryEmitNext(chat);
        log.info("chat {} ",chat);

        return true;
    }
}
