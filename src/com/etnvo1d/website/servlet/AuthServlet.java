package com.etnvo1d.website.servlet;

import com.etnvo1d.website.dao.UserDAO;
import com.etnvo1d.website.entity.User;
import com.etnvo1d.website.util.CookieUtil;
import com.etnvo1d.website.util.JWTUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Map;

@WebServlet("/api/auth")
public class AuthServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        Map<String, String> cookies = CookieUtil.getCookies(request.getCookies());
        String token = cookies.get("token");
        PrintWriter out = response.getWriter();

        if (cookies.get("token") != null) {
            try {
                String uid = JWTUtil.decode(token);
                User user = UserDAO.queryUser(uid);
                out.print("{\"success\":true, \"uid\": \"" + uid + "\", \"type\": " + user.getType() + "}");
            } catch (Exception e) {
                out.print("{\"success\":false,\"message\":\"请重新登录\"}");
            }
        } else {
            out.print("{\"success\":false,\"message\":\"未登录\"}");
        }
    }
}
