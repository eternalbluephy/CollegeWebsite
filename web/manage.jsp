<%@ page import="com.etnvo1d.website.entity.Article" %>
<%@ page import="java.util.List" %>
<%@ page import="com.etnvo1d.website.dao.ArticleDAO" %>
<%@ page import="com.etnvo1d.website.util.DateUtil" %>
<%@ page import="com.etnvo1d.website.entity.Article" %>
<%@ page import="com.etnvo1d.website.entity.Question" %>
<%@ page import="com.etnvo1d.website.dao.QuestionDAO" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ include file="component/header.jsp"%>

<!DOCTYPE html>
<head>
  <meta charset="UTF-8">
  <base href="<%=basePath%>">
  <link rel="stylesheet" type="text/css" href="main.css">
  <link rel="stylesheet" type="text/css" href="<%=basePath%>/bootstrap/css/bootstrap.min.css">
  <title>管理</title>
  <script type="text/javascript" src="<%=basePath%>/jquery.js"></script>
</head>

<body>
<%@include file="component/navbar.jsp"%>
<%
  if ((int)session.getAttribute("type") != 1) {
    out.println("<script>alert('权限不足')</script>");
    return;
  }
%>
<div class="container margin-t-lg">
  <div class="row">
    <div class="col-md-3">
      <div class="list-group">
        <a href="manage.jsp?type=0" class="list-group-item list-group-item-action active">新闻动态</a>
        <a href="manage.jsp?type=1" class="list-group-item list-group-item-action">学院概况</a>
        <a href="manage.jsp?type=2" class="list-group-item list-group-item-action">学科建设</a>
        <a href="manage.jsp?type=3" class="list-group-item list-group-item-action">招生就业</a>
      </div>
    </div>
    <div class="col-md-9 bg-white">
      <div class="d-flex justify-content-end">
        <a href="${pageContext.request.contextPath}/edit.jsp">
          <button class="btn-primary btn margin-y">新增</button>
        </a>
      </div>
      <%
        int type = request.getParameter("type") != null ? Integer.parseInt(request.getParameter("type")) : 0;
        int curPage = request.getParameter("page") != null ? Integer.parseInt(request.getParameter("page")) : 1;
        List<Article> articles = ArticleDAO.queryArticlesByPage(curPage, type);
        if (articles.isEmpty()) {
          out.println("<p class='text-center mt-4'>暂无数据</p>");
        } else {
        int totalPages = ArticleDAO.countArticlePages(type);
      %>
      <table class="table">
        <thead>
          <tr>
            <th>标题</th>
            <th>发布时间</th>
            <th>操作</th>
          </tr>
        </thead>
        <tbody>
          <% for(Article article : articles) { %>
          <tr>
            <td><%= article.getTitle() %></td>
            <td><%= article.getTime() %></td>
            <td>
              <button class="btn btn-primary btn-sm" onclick="window.location.href='edit.jsp?id=<%= article.getId() %>'">编辑</button>
              <button class="btn btn-danger btn-sm" onclick="if(confirm('确定删除?')) window.location.href='delete.jsp?id=<%= article.getId() %>'">删除</button>
            </td>
          </tr>
          <% } %>
        </tbody>
      </table>
      <nav aria-label="Page navigation" class="mt-4">
        <ul class="pagination justify-content-center">
          <li class="page-item <%= curPage <= 1 ? "disabled" : "" %>">
            <a class="page-link" href="news.jsp?page=<%= curPage-1 %>" aria-label="Previous">
              <span aria-hidden="true">&laquo;</span>
            </a>
          </li>
          <% for(int i = 1; i <= totalPages; i++) { %>
          <li class="page-item <%= i == curPage ? "active" : "" %>">
            <span class="page-link text-white"><%= i %></span>
          </li>
          <% } %>
          <li class="page-item <%= curPage >= totalPages ? "disabled" : "" %>">
            <a class="page-link" href="news.jsp?page=<%= curPage+1 %>" aria-label="Next">
              <span aria-hidden="true">&raquo;</span>
            </a>
          </li>
        </ul>
      </nav>
      <% } %>
    </div>
  </div>
</div>

<script type="text/javascript" src="<%=basePath%>/bootstrap/js/bootstrap.bundle.js"></script>
</body>

<style>
  .list-group-item-action.active {
    color: #fff !important;
  }
</style>