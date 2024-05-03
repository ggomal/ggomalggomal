package com.ssafy.ggomalbe.common.config.security;

import com.ssafy.ggomalbe.common.entity.MemberEntity;
import lombok.Builder;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;

import java.security.Principal;
import java.util.Collection;
import java.util.Map;

@RequiredArgsConstructor
@Builder
public class CustomAuthentication implements Authentication {
    private final Long memberId;
    private final String name;
    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        return null;
    }

    @Override
    public Object getCredentials() {
        return null;
    }

    /** return memberId; */
    @Override
    public Long getDetails() {
        return memberId;
    }

    @Override
    public Principal getPrincipal() {
        return () -> name;
    }

    @Override
    public boolean isAuthenticated() {
        return true;
    }

    @Override
    public void setAuthenticated(boolean isAuthenticated) throws IllegalArgumentException {

    }

    @Override
    public String getName() {
        return name;
    }

}
