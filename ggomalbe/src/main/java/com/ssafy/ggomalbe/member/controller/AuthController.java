package com.ssafy.ggomalbe.member.controller;

import com.ssafy.ggomalbe.common.config.security.CustomUserDetails;
import com.ssafy.ggomalbe.common.config.security.JWTUtil;
import com.ssafy.ggomalbe.common.entity.MemberEntity;
import com.ssafy.ggomalbe.member.dto.KidSignUpRequest;
import com.ssafy.ggomalbe.member.dto.LoginRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.userdetails.ReactiveUserDetailsService;
import org.springframework.security.core.userdetails.UserDetails;
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
    public Mono<ResponseEntity<String>> login(@RequestBody LoginRequest user) {
        return users.findByUsername(user.getId())
                .defaultIfEmpty(new CustomUserDetails(null))
                .map(u -> {
                    if (u != null) {
                        if (u.getPassword().equals(user.getPassword())) {
                            return ResponseEntity.ok(
                                    jwtUtil.generateToken((CustomUserDetails) u)
                            );
                        }
                        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Invalid Credentials");
                    }
                    return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("User not found. Please register");
                });
    }


    @PostMapping("/kid")
    public Mono<MemberEntity> kidSignUp(@RequestBody KidSignUpRequest request) {
        return null;
    }

    @PostMapping("/teacher")
    public Mono<MemberEntity> teacherSignUp(){
        return null;
    }
}
