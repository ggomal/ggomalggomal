package com.ssafy.ggomalbe.common.config.security;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.server.reactive.ServerHttpRequest;
import org.springframework.http.server.reactive.ServerHttpResponse;
import org.springframework.security.config.annotation.method.configuration.EnableReactiveMethodSecurity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.ReactiveSecurityContextHolder;
import org.springframework.util.StringUtils;
import org.springframework.web.server.ServerWebExchange;
import org.springframework.web.server.WebFilter;
import org.springframework.web.server.WebFilterChain;
import reactor.core.publisher.Mono;

@Configuration
@EnableReactiveMethodSecurity
@Slf4j
public class SecurityWebFilter implements WebFilter {
    @Autowired
    JWTUtil jwtUtil;
    public static final String HEADER_PREFIX = "Bearer ";

    @Override
    public Mono<Void> filter(ServerWebExchange exchange, WebFilterChain chain) {
        String token = resolveToken(exchange.getRequest());
        if (token == null) {
            log.info("no jwt");
            return chain.filter(exchange);
        }
        if (jwtUtil.validateToken(token)) {
            Authentication authentication = CustomAuthentication.builder()
                    .memberId(jwtUtil.getMemberIdFromToken(token))
                    .name(jwtUtil.getMemberNameFromToken(token))
                    .centerId(jwtUtil.getCenterIdFromToken(token))
                    .role(jwtUtil.getRoleFromToken(token))
                    .build();
            return chain.filter(exchange)
                    .contextWrite(context ->
                            context.putAll(ReactiveSecurityContextHolder.withAuthentication(authentication)));
        }
        // token  인증 실패시
        log.info("jwt validate false");
        Authentication authentication = CustomAuthentication.builder().build();
        return chain.filter(exchange)
                .contextWrite(context ->
                        context.putAll(ReactiveSecurityContextHolder.withAuthentication(authentication)));
//        // 안되면 임시로 3번 넣어보기
    }

    private String resolveToken(ServerHttpRequest request) {
        String bearerToken = request.getHeaders().getFirst(HttpHeaders.AUTHORIZATION);
        if (StringUtils.hasText(bearerToken) && bearerToken.startsWith(HEADER_PREFIX)) {
            return bearerToken.substring(7);
        }
        return null;
    }
}
