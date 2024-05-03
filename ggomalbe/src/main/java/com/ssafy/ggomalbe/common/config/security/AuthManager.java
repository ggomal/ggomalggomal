package com.ssafy.ggomalbe.common.config.security;

import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Bean;
import org.springframework.security.authentication.ReactiveAuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.ReactiveUserDetailsService;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Component;
import reactor.core.publisher.Mono;

import java.util.Collection;

@Component
public class AuthManager implements ReactiveAuthenticationManager {
    final JWTUtil jwtUtil;
    final ReactiveUserDetailsService users;

    public AuthManager(JWTUtil jwtUtil, ReactiveUserDetailsService users){
        this.jwtUtil = jwtUtil; this.users = users;
    }

    @Override
    public Mono<Authentication> authenticate(Authentication authentication) {
        return Mono.justOrEmpty(
                        authentication
                )
                .cast(BearerToken.class)
                .map(BearerToken::getCredentials)
                .filter(jwtUtil::validateToken)
                .flatMap(token -> {
                    String userName = jwtUtil.getUsernameFromToken(token);
                    Mono<UserDetails> foundUser = users.findByUsername(userName).defaultIfEmpty(new CustomUserDetails(null));

                    return foundUser.flatMap(u -> {
                        if (u.getUsername() == null) {
                            Mono.error(new IllegalArgumentException("User not found in auth manager"));
                        }
                        if (jwtUtil.validateToken(token)) {
                            return Mono.justOrEmpty(new UsernamePasswordAuthenticationToken(u.getUsername(), u.getPassword(), u.getAuthorities()));
                        }
                        Mono.error(new IllegalArgumentException("Invalid Token or Expired token"));
                        return Mono.justOrEmpty(new UsernamePasswordAuthenticationToken(u.getUsername(), u.getPassword(), u.getAuthorities()));
                    });
                });
    }
}
