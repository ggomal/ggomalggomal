package com.ssafy.ggomalbe.common.util;

import org.apache.commons.lang3.RandomStringUtils;

public class TokenGenerator {
    private static final int TOKEN_LENGTH = 10;

    public static String randomCharacter(int length){
        return RandomStringUtils.randomAlphanumeric(length);
    }

    public static String randomCharacterWithPrefix(String prefix){
        return prefix + randomCharacter(TOKEN_LENGTH - prefix.length());
    }
    public static String randomCharacterWithPrefix(String prefix, int length){
        return prefix + randomCharacter(length);
    }
}
