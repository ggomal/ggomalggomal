package com.ssafy.ggomalbe.statistics;

import com.ssafy.ggomalbe.statistics.dto.StatisticResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.context.ReactiveSecurityContextHolder;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import reactor.core.publisher.Mono;

@RestController
@RequestMapping("/statistics")
@RequiredArgsConstructor
public class StatisticsController {
    private final StatisticsService statisticsService;
    @GetMapping
    public Mono<StatisticResponse> getStatistic(){
        return ReactiveSecurityContextHolder.getContext()
                .map(securityContext ->
                        (Long) securityContext.getAuthentication().getDetails())
                .flatMap(statisticsService::getStatistic);
    }

}
