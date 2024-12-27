<%@ page import="com.etnvo1d.website.dao.UserDAO" %>
<%@ page import="com.etnvo1d.website.entity.User" %>
<%@ page import="org.mindrot.jbcrypt.BCrypt" %>
<%@ page import="com.etnvo1d.website.util.JWTUtil" %><%
    String id = request.getParameter("id");
    String password = request.getParameter("password");
    boolean rememberMe = Boolean.parseBoolean(request.getParameter("rememberMe"));

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
%>