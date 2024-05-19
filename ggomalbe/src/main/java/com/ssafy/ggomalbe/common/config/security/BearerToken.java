package com.ssafy.ggomalbe.common.config.security;

import org.springframework.security.authentication.AbstractAuthenticationToken;
import org.springframework.security.core.authority.AuthorityUtils;


public class BearerToken extends AbstractAuthenticationToken {
    final private String token;

    public BearerToken(String token){
        super(AuthorityUtils.NO_AUTHORITIES);
        this.token = token;
    }
    @Override
    public String getCredentials() {
        return token;
    }

    @Override
    public Object getPrincipal() {
        return null;
    }
}
