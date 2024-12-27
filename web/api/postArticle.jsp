<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.etnvo1d.website.dao.ContentDAO"%>
<%@ page import="com.fasterxml.jackson.databind.ObjectMapper"%>
<%@ page import="com.fasterxml.jackson.databind.node.ObjectNode"%><%@ page import="com.fasterxml.jackson.databind.JsonNode"%><%@ page import="java.util.stream.Collectors"%><%@ page import="org.apache.commons.fileupload2.jakarta.JakartaServletFileUpload"%><%@ page import="org.apache.commons.fileupload2.core.DiskFileItemFactory"%><%@ page import="org.apache.commons.fileupload2.core.FileItem"%><%@ page import="java.util.List"%><%@ page import="java.nio.charset.Charset"%><%@ page import="static java.nio.charset.Charset.*"%><%@ page import="java.nio.charset.StandardCharsets"%><%@ page import="com.etnvo1d.website.dao.ArticleDAO"%>
<%
  response.setContentType("application/json");
  ObjectMapper mapper = new ObjectMapper();
  ObjectNode result = mapper.createObjectNode();
  
  try {
    request.setCharacterEncoding("UTF-8");

    DiskFileItemFactory.Builder builder = new DiskFileItemFactory.Builder();
        DiskFileItemFactory factory = builder.get();
        JakartaServletFileUpload upload = new JakartaServletFileUpload(factory);

        // 解析请求
        List<FileItem> items = upload.parseRequest(request);
        
        String id = "", title = "", cover = "", content = "", type = "";
        
        // 处理表单字段
        for (FileItem item : items) {
            if (item.isFormField()) {
                String fieldName = item.getFieldName();
                String fieldValue = item.getString(StandardCharsets.UTF_8);
                
                switch(fieldName) {
                    case "id": id = fieldValue; break;
                    case "title": title = fieldValue; break;
                    case "cover": cover = fieldValue; break;
                    case "content": content = fieldValue; break;
                    case "type": type = fieldValue; break;
                }
            }
        }
        int contentId = ContentDAO.upsert(id.equals("0") ? null : Integer.parseInt(id), content);
        if (id.equals("0")) {
            System.out.println(contentId);
            ArticleDAO.upsert(
                null, title, cover.trim(), contentId, Integer.parseInt(type));
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
%>