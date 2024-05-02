package com.ssafy.ggomalbe.common.config.security;

import com.ssafy.ggomalbe.common.repository.MemberRepository;
import lombok.AllArgsConstructor;
import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.method.configuration.EnableReactiveMethodSecurity;
import org.springframework.security.config.annotation.web.reactive.EnableWebFluxSecurity;
import org.springframework.security.config.web.server.ServerHttpSecurity;
import org.springframework.security.core.userdetails.MapReactiveUserDetailsService;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.web.server.SecurityWebFilterChain;
import org.springframework.security.web.server.util.matcher.PathPatternParserServerWebExchangeMatcher;


@AllArgsConstructor
@Configuration
@EnableReactiveMethodSecurity
@EnableWebFluxSecurity
public class SecurityConfig {
    //    @Order(Ordered.HIGHEST_PRECEDENCE)
//    @Bean
//    SecurityWebFilterChain apiHttpSecurity(ServerHttpSecurity http) {
//        http
//                .authorizeExchange((exchanges) -> exchanges
//                        .anyExchange().authenticated()
//                );
//        return http.build();
//    }
    @Bean
    public SecurityWebFilterChain securityWebFilterChain(ServerHttpSecurity http){
        http
                .authorizeExchange(exchanges -> exchanges
                        .pathMatchers("/swagger-ui.html", "/v3/api-docs/**", "/api-docs/**", "/swagger-ui/**", "/swagger-resources/**", "/webjars/**").permitAll()
                        .anyExchange().authenticated())
                .securityMatcher(new PathPatternParserServerWebExchangeMatcher("/api/v1/**"))
                .csrf(ServerHttpSecurity.CsrfSpec::disable)
                .formLogin(ServerHttpSecurity.FormLoginSpec::disable)
                .httpBasic(ServerHttpSecurity.HttpBasicSpec::disable);
        return http.build();
    }
    @Bean
    public MapReactiveUserDetailsService userDetailsService() {
        UserDetails user = User.withDefaultPasswordEncoder()
                .username("user")
                .password("password")
                .roles("USER")
                .build();
        return new MapReactiveUserDetailsService(user);
    }
}
