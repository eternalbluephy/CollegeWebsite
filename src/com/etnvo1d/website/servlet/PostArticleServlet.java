package com.etnvo1d.website.servlet;

import com.etnvo1d.website.dao.ArticleDAO;
import com.etnvo1d.website.dao.ContentDAO;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.apache.commons.fileupload2.core.DiskFileItemFactory;
import org.apache.commons.fileupload2.core.FileItem;
import org.apache.commons.fileupload2.jakarta.JakartaServletFileUpload;

import java.io.IOException;
import java.io.PrintWriter;
import java.nio.charset.StandardCharsets;
import java.util.List;

@WebServlet("/api/postArticle")
public class PostArticleServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        ObjectMapper mapper = new ObjectMapper();
        ObjectNode result = mapper.createObjectNode();
        PrintWriter out = response.getWriter();

        try {
            request.setCharacterEncoding("UTF-8");

            DiskFileItemFactory.Builder builder = new DiskFileItemFactory.Builder();
            DiskFileItemFactory factory = builder.get();
            JakartaServletFileUpload upload = new JakartaServletFileUpload(factory);

            List<FileItem> items = upload.parseRequest(request);
            String idStr = "", title = "", cover = "", content = "", typeStr = "";
            for (FileItem item : items) {
                if (item.isFormField()) {
                    String fieldName = item.getFieldName();
                    String fieldValue = item.getString(StandardCharsets.UTF_8);

                    switch(fieldName) {
                        case "id": idStr = fieldValue; break;
                        case "title": title = fieldValue; break;
                        case "cover": cover = fieldValue; break;
                        case "content": content = fieldValue; break;
                        case "type": typeStr = fieldValue; break;
                    }
                }
            }
            int id = Integer.parseInt(idStr);
            int type = Integer.parseInt(typeStr);
            cover = cover.trim();

            int contentId = ContentDAO.upsert(id == 0 ? null : id, content);
            if (id == 0) { // 新增文章
                ArticleDAO.insert(title, cover.trim(), contentId, type);
            } else if (!cover.isEmpty()) {
                ArticleDAO.update(id, title, cover.trim(), contentId, type);
            } else {
                ArticleDAO.update(id, title, contentId, type);
            }

            if (contentId != -1) {
                result.put("success", true);
                result.put("id", contentId);
            } else {
                result.put("success", false);
                result.put("message", "文章更新失败");
            }

        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("message", "系统错误：" + e.getMessage());
        }

        mapper.writeValue(response.getWriter(), result);
        response.setContentType("application/json");
        out.println(mapper.toString());
    }
}
