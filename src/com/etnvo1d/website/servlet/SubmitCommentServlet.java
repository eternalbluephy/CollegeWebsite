package com.etnvo1d.website.servlet;

import com.etnvo1d.website.dao.AnswersDAO;
import com.etnvo1d.website.dao.UserDAO;
import com.etnvo1d.website.entity.User;
import com.etnvo1d.website.util.CookieUtil;
import com.etnvo1d.website.util.JWTUtil;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Map;

@WebServlet("/api/submitComment")
public class SubmitCommentServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        Map<String, String> cookies = CookieUtil.getCookies(request.getCookies());
        String token = cookies.get("token");
        PrintWriter out = response.getWriter();
        ObjectMapper mapper = new ObjectMapper();
        JsonNode node;
        try {
            node = mapper.readTree(request.getInputStream());
        } catch (Exception e) {
            out.print("{\"success\":false,\"message\":\"参数错误\"}");
            return;
        }

        if (!node.has("id") || !node.has("content")) {
            out.print("{\"success\":false,\"message\":\"参数错误\"}");
            return;
        }
        int id = node.get("id").asInt();
        String content = node.get("content").asText();

        User user = new User();
        if (cookies.get("token") != null) {
            try {
                String uid = JWTUtil.decode(token);
                user = UserDAO.queryUser(uid);
            } catch (Exception e) {
                out.print("{\"success\":false,\"message\":\"请重新登录\"}");
            }
        } else {
            out.print("{\"success\":false,\"message\":\"请先登录\"}");
        }

        try {
            AnswersDAO.insert(id, user.getId(), content);
        } catch (Exception e) {
            out.print("{\"success\":false,\"message\":\"" + e.getMessage() + "\"}");
            return;
        }
        out.print("{\"success\":true}");
    }
}
