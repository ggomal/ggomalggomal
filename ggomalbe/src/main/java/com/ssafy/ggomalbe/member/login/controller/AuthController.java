package com.ssafy.ggomalbe.member.login.controller;

import com.ssafy.ggomalbe.common.config.security.CustomUserDetails;
import com.ssafy.ggomalbe.common.config.security.JWTUtil;
import com.ssafy.ggomalbe.member.login.dto.LoginRequest;
import com.ssafy.ggomalbe.member.login.dto.LoginResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.userdetails.ReactiveUserDetailsService;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;
import reactor.core.publisher.Mono;

@RestController
@RequiredArgsConstructor
public class AuthController {

    private final ReactiveUserDetailsService users;
    private final JWTUtil jwtUtil;

    @PostMapping("/login")
    public Mono<ResponseEntity<LoginResponse>> login(@RequestBody LoginRequest user) {
        return users.findByUsername(user.getId())
                .defaultIfEmpty(new CustomUserDetails(null))
                .map(u -> {
                    if (u != null) {
                        if (u.getPassword().equals(user.getPassword())) {
                            return ResponseEntity.ok(
                                    LoginResponse.builder()
                                            .msg("Success")
                                            .jwt(jwtUtil.generateToken((CustomUserDetails) u))
                                            .role(((CustomUserDetails) u).getRole())
                                            .build()
                            );
                        }
                        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(
                                LoginResponse.builder().msg("Invalid Credentials").build());
                    }
                    return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(
                            LoginResponse.builder().msg("User not found. Please register").build());
                });
    }
}
