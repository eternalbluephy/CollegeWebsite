package com.etnvo1d.website.util;

import com.auth0.jwt.JWT;
import com.auth0.jwt.JWTCreator;
import com.auth0.jwt.algorithms.Algorithm;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;

public class JWTUtil {
    private static final String KEY = "CollegeWebsite";

    public static String encode(String uid, boolean rememberMe) {
        JWTCreator.Builder jwtBuilder = JWT.create();
        Map<String, Object> headers = new HashMap<>();
        headers.put("typ", "jwt");
        headers.put("alg", "hs256");
        int duration = 1000 * 60 * 60 * 24;
        if (rememberMe) duration *= 7;
        return jwtBuilder.withHeader(headers)
                .withClaim("id", uid)
                .withExpiresAt(new Date(System.currentTimeMillis() + duration))
                .sign(Algorithm.HMAC256(KEY));
    }

    public static String decode(String token) {
        return JWT.require(Algorithm.HMAC256(KEY))
                .build()
                .verify(token)
                .getClaim("id")
                .asString();
    }
}
