package com.ssafy.ggomalbe.common.config.security;

import lombok.Builder;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.stereotype.Component;

import java.security.Principal;
import java.util.Collection;

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

    /** return memberId */
    @Override
    public Long getDetails() {
        return memberId;
    }

    /** return name */
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
