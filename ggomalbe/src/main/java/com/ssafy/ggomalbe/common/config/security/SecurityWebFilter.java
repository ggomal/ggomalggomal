package com.ssafy.ggomalbe.common.config.security;

import com.ssafy.ggomalbe.common.entity.MemberEntity;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatusCode;
import org.springframework.http.server.reactive.ServerHttpRequest;
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
public class SecurityWebFilter implements WebFilter {
    @Autowired
    JWTUtil jwtUtil;
    public static final String HEADER_PREFIX = "Bearer ";

    @Override
    public Mono<Void> filter(ServerWebExchange exchange, WebFilterChain chain) {
        String token = resolveToken(exchange.getRequest());

        if (token != null && jwtUtil.validateToken(token)) {
            jwtUtil.getUsernameFromToken(token);
            Authentication authentication = CustomAuthentication.builder()
                    .memberId(jwtUtil.getMemberIdFromToken(token))
                    .name(jwtUtil.getUsernameFromToken(token))
                    .build();
            return chain.filter(exchange)
                    .contextWrite(context ->
                            context.putAll(ReactiveSecurityContextHolder.withAuthentication(authentication)));
        }
        Authentication authentication = CustomAuthentication.builder()
                .memberId(3L)
                .build();
        return chain.filter(exchange)
                .contextWrite(context ->
                        context.putAll(ReactiveSecurityContextHolder.withAuthentication(authentication)));
    }

    private String resolveToken(ServerHttpRequest request) {
        String bearerToken = request.getHeaders().getFirst(HttpHeaders.AUTHORIZATION);
        if (StringUtils.hasText(bearerToken) && bearerToken.startsWith(HEADER_PREFIX)) {
            return bearerToken.substring(7);
        }
        return null;
    }
}
