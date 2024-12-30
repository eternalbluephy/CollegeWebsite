package com.etnvo1d.website.servlet;

import com.etnvo1d.website.dao.UserDAO;
import com.etnvo1d.website.entity.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.mindrot.jbcrypt.BCrypt;

import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/api/postUser")
public class PostUserServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();

        String targetId = request.getParameter("target");
        String id = request.getParameter("id");
        String name = request.getParameter("name");
        String password = request.getParameter("password");
        String updateStr = request.getParameter("update");
        if (id == null || name == null || updateStr == null) {
            out.print("{\"success\": false, \"message\": \"参数错误\"}");
            return;
        }
        if (password != null && (password.length() < 6 || password.length() > 12)) {
            out.print("{\"success\": false, \"message\": \"参数错误\"}");
            return;
        }

        try {
            boolean update = Boolean.parseBoolean(updateStr);
            User user = UserDAO.queryUser(id);
            if (!update && user != null) {
                out.print("{\"success\": false, \"message\": \"用户ID已存在\"}");
                return;
            } else if (update && user == null) {
                out.print("{\"success\": false, \"message\": \"用户不存在\"}");
                return;
            }
            if (update) {
                if (password == null) UserDAO.update(id, name);
                else UserDAO.update(id, name, BCrypt.hashpw(password, BCrypt.gensalt()));
            } else {
                UserDAO.insert(id, name, BCrypt.hashpw(password, BCrypt.gensalt()));
            }

        } catch (Exception e) {
            out.print("{\"success\": false, \"message\": \"" + e.getMessage() + "\"}");
            return;
        }
        out.print("{\"success\": true}");
    }
}
