<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.apache.commons.fileupload2.core.DiskFileItemFactory"%>
<%@ page import="org.apache.commons.fileupload2.core.FileItem"%>
<%@ page import="org.apache.commons.fileupload2.jakarta.JakartaServletFileUpload"%>
<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>

<%
  response.setContentType("application/json;charset=UTF-8");
  
  try {
    boolean isMultipart = JakartaServletFileUpload.isMultipartContent(request);
    if (!isMultipart) {
      out.println("{\"success\":false,\"msg\":\"Invalid request\"}");
      return;
    }

    DiskFileItemFactory.Builder builder = new DiskFileItemFactory.Builder();
    DiskFileItemFactory diskFileItemFactory = builder.get();
    JakartaServletFileUpload upload = new JakartaServletFileUpload(diskFileItemFactory);
    List<FileItem> items = upload.parseRequest(request);
    
    for (FileItem item : items) {
      if (!item.isFormField() && "editorImage".equals(item.getFieldName())) {
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
%>