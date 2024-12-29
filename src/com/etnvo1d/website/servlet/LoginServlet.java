package com.etnvo1d.website.servlet;

import com.etnvo1d.website.dao.UserDAO;
import com.etnvo1d.website.entity.User;
import com.etnvo1d.website.util.JWTUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.mindrot.jbcrypt.BCrypt;

import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/api/login")
public class LoginServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String id = request.getParameter("id");
        String password = request.getParameter("password");
        boolean rememberMe = Boolean.parseBoolean(request.getParameter("rememberMe"));
        PrintWriter out = response.getWriter();

        if (id == null || id.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            response.setContentType("application/json");
            out.print("{\"success\":false,\"message\":\"用户名或密码不能为空\"}");
            return;
        }

        User user = UserDAO.queryUser(id);
        if (user == null) {
            response.setContentType("application/json");
            out.print("{\"success\":false,\"message\":\"用户名不存在\"}");
            return;
        }
        if (!BCrypt.checkpw(password, user.getPassword())) {
            response.setContentType("application/json");
            out.print("{\"success\":false,\"message\":\"密码错误\"}");
            return;
        }

        String token = JWTUtil.encode(id, rememberMe);
        response.setContentType("application/json");
        out.print("{\"success\":true,\"token\":\"" + token + "\"}");
    }
}
