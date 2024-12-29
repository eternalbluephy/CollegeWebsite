package com.etnvo1d.website.servlet;

import com.etnvo1d.website.dao.ArticleDAO;
import com.etnvo1d.website.dao.ContentDAO;
import com.etnvo1d.website.entity.Article;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/api/removeArticle")
public class RemoveArticleServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();

        String idStr = request.getParameter("id");
        if (idStr == null) {
            out.print("{\"success\": false, \"message\": \"参数错误\"}");
            return;
        }
        try {
            int id = Integer.parseInt(idStr);
            Article article = ArticleDAO.getArticleDetail(id);
            ArticleDAO.remove(id);
            ContentDAO.remove(article.getContentId());
        } catch (NumberFormatException e) {
            out.print("{\"success\": false, \"message\": \"参数错误\"}");
            return;
        }
        out.print("{\"success\": true}");
    }
}
