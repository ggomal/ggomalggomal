package com.ssafy.ggomalbe.statistics;

import com.ssafy.ggomalbe.statistics.dto.StatisticResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.context.ReactiveSecurityContextHolder;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import reactor.core.publisher.Mono;

@RestController
@RequestMapping("/statistics")
@RequiredArgsConstructor
public class StatisticsController {
    private final StatisticsService statisticsService;
    @GetMapping
    public Mono<StatisticResponse> getStatistic(@RequestParam(value = "kidId", required = false) Long kidId){
        return ReactiveSecurityContextHolder.getContext()
                .map(securityContext ->
                        (Long) securityContext.getAuthentication().getDetails())
                .map(memberId-> kidId==null?memberId:kidId)
                .flatMap(statisticsService::getStatistic);
    }

}
