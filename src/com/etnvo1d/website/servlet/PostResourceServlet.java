package com.etnvo1d.website.servlet;

import com.etnvo1d.website.dao.ArticleDAO;
import com.etnvo1d.website.dao.ContentDAO;
import com.etnvo1d.website.dao.ResourcesDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.apache.commons.fileupload2.core.DiskFileItemFactory;
import org.apache.commons.fileupload2.core.FileItem;
import org.apache.commons.fileupload2.jakarta.JakartaServletFileUpload;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.nio.charset.StandardCharsets;
import java.util.List;

@WebServlet("/api/postResource")
public class PostResourceServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();

        boolean isMultipart = JakartaServletFileUpload.isMultipartContent(request);
        if (!isMultipart) {
            out.println("{\"success\":false,\"msg\":\"Invalid request\"}");
            return;
        }

        try {
            request.setCharacterEncoding("UTF-8");

            DiskFileItemFactory.Builder builder = new DiskFileItemFactory.Builder();
            DiskFileItemFactory factory = builder.get();
            JakartaServletFileUpload upload = new JakartaServletFileUpload(factory);

            List<FileItem> items = upload.parseRequest(request);
            String idStr = "", title = "", path = "";
            for (FileItem item : items) {
                if (item.isFormField()) {
                    String fieldName = item.getFieldName();
                    String fieldValue = item.getString(StandardCharsets.UTF_8);

                    switch(fieldName) {
                        case "id": idStr = fieldValue; break;
                        case "title": title = fieldValue; break;
                        case "path": path = fieldValue; break;
                    }
                }
            }
            int id = Integer.parseInt(idStr);
            path = path.trim();

            if (id == 0) {
                ResourcesDAO.insert(title, path);
            } else if (path.isEmpty()) {
                ResourcesDAO.update(id, title);
            } else {
                ResourcesDAO.update(id, title, path);
            }
            out.println("{\"success\": true}");

        } catch (Exception e) {
            e.printStackTrace();
            out.println("{\"success\": false, \"message\": \"" + e.getMessage() + "\"}");
        }
    }
}
