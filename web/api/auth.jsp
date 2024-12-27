<%@ page import="com.etnvo1d.website.util.JWTUtil" %>
<%@ page import="com.etnvo1d.website.entity.User" %>
<%@ page import="com.etnvo1d.website.dao.UserDAO" %>
<%
    response.setContentType("application/json");
    String authHeader = request.getHeader("Authorization");
    String token = null;
    String uid = null;

    if (authHeader != null && authHeader.startsWith("Bearer ")) {
        token = authHeader.substring(7);
        try {
            uid = JWTUtil.decode(token);
            User user = UserDAO.queryUser(uid);
            session.setAttribute("isLogined", true);
            session.setAttribute("uid", uid);
            session.setAttribute("type", user.getType());
            out.print("{\"success\":true}");
        } catch (Exception e) {
            session.setAttribute("isLogined", false);
            session.setAttribute("uid", 0);
            session.setAttribute("type", 0);
            out.print("{\"success\":false,\"message\":\"请重新登录\"}");
        }
    } else {
        session.setAttribute("isLogined", false);
        session.setAttribute("uid", 0);
        session.setAttribute("type", 0);
        out.print("{\"success\":false,\"message\":\"未登录\"}");
    }
%>