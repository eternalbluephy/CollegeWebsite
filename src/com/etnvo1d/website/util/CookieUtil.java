package com.etnvo1d.website.util;

import jakarta.servlet.http.Cookie;

import java.util.HashMap;
import java.util.Map;

public class CookieUtil {
    public static Map<String,String> getCookies(Cookie[] cookies){
        Map<String,String> cookieMap = new HashMap<String,String>();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                cookieMap.put(cookie.getName(), cookie.getValue());
            }
        }
        return cookieMap;
    }

    public static String toString(Cookie[] cookies){
        String cookieStr = "";
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                cookieStr += cookie.getName() + "=" + cookie.getValue() + ";";
            }
        }
        return cookieStr;
    }
}
