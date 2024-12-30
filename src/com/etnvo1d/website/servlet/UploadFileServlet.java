package com.etnvo1d.website.servlet;

import jakarta.servlet.ServletContext;
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
import java.util.List;

@WebServlet("/api/uploadFile")
public class UploadFileServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        ServletContext application = this.getServletContext();
        try {
            DiskFileItemFactory.Builder builder = new DiskFileItemFactory.Builder();
            DiskFileItemFactory diskFileItemFactory = builder.get();
            JakartaServletFileUpload upload = new JakartaServletFileUpload(diskFileItemFactory);
            List<FileItem> items = upload.parseRequest(request);

            for (FileItem item : items) {
                if (!item.isFormField() && "file".equals(item.getFieldName())) {
                    String fileName = System.currentTimeMillis() + "_" + item.getName();
                    String uploadPath = application.getRealPath("/uploads/");
                    File uploadDir = new File(uploadPath);
                    if (!uploadDir.exists()) {
                        uploadDir.mkdir();
                    }

                    File file = new File(uploadPath + File.separator + fileName);
                    item.write(file.toPath());

                    String fileUrl = request.getContextPath() + "/uploads/" + fileName;
                    out.println(fileUrl);
                    return;
                }
            }

            out.println("{\"success\":false,\"msg\":\"No file found\"}");

        } catch (Exception e) {
            out.println("{\"success\":false,\"msg\":\"" + e.getMessage() + "\"}");
        }
    }
}
