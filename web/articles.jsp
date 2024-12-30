<%@ page import="com.etnvo1d.website.entity.Article" %>
<%@ page import="java.util.List" %>
<%@ page import="com.etnvo1d.website.dao.ArticleDAO" %>
<%@ page import="com.etnvo1d.website.util.DateUtil" %>
<%@ page import="com.etnvo1d.website.entity.Article" %>
<%@ page import="com.etnvo1d.website.entity.Question" %>
<%@ page import="com.etnvo1d.website.dao.QuestionDAO" %>
<%@ page import="java.util.HashMap" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ include file="component/header.jsp"%>

<!DOCTYPE html>
<head>
  <meta charset="UTF-8">
  <base href="<%=basePath%>">
  <link rel="stylesheet" type="text/css" href="main.css">
  <link rel="stylesheet" type="text/css" href="<%=basePath%>/bootstrap/css/bootstrap.min.css">
  <title>计算机科学与技术学院</title>
  <script type="text/javascript" src="<%=basePath%>/jquery.js"></script>

  <%
    HashMap<Integer, String> typeMap = new HashMap<>();
    typeMap.put(0, "新闻动态");
    typeMap.put(1, "学院概况");
    typeMap.put(2, "学科建设");
    typeMap.put(3, "招生就业");

    String typeStr = request.getParameter("type");
    if (typeStr == null) return;
    int type = Integer.parseInt(typeStr);
    if (!typeMap.containsKey(type)) return;
    String pageStr = request.getParameter("page");
    int curPage = pageStr == null ? 1 : Integer.parseInt(pageStr);
    int totalCount = ArticleDAO.countArticles(type);
    int totalPages = (int) Math.ceil(totalCount / 12.0);
  %>
</head>

<body>
<%@include file="component/navbar.jsp"%>
<div class="container margin-t-lg">
  <div class="m-row spacebetween">
    <h3><%=typeMap.get(type)%></h3>
    <span class="text-secondary">共 <%=totalCount%> 条</span>
  </div>
  <div class="row margin-t">
    <%
      List<Article> articles = ArticleDAO.queryArticlesByPage(curPage, type);
      for (Article article : articles) {
    %>
      <div class="col-12 mb-3">
        <div class="card">
          <div class="card-body">
            <div class="m-row spacebetween">
              <a href="article.jsp?id=<%=article.getId()%>">
                <h5><%= article.getTitle() %></h5>
              </a>
              <span class="mb-2 text-secondary">浏览 <%=article.getViews()%> 次</span>
            </div>
            <span class="text-secondary"><%= DateUtil.dateToString(article.getTime()) %></span>
          </div>
        </div>
      </div>
    <% } %>
  </div>
  <% if (totalCount > 0) { %>
  <nav aria-label="Page navigation" class="mt-4">
    <ul class="pagination justify-content-center">
      <li class="page-item <%= curPage <= 1 ? "disabled" : "" %>">
        <a class="page-link" href="articles.jsp?page=<%= curPage-1 %>" aria-label="Previous">
          <span aria-hidden="true">&laquo;</span>
        </a>
      </li>
      <% for(int i = 1; i <= totalPages; i++) { %>
      <li class="page-item <%= i == curPage ? "active" : "" %>">
        <span class="page-link text-white"><%= i %></span>
      </li>
      <% } %>
      <li class="page-item <%= curPage >= totalPages ? "disabled" : "" %>">
        <a class="page-link" href="articles.jsp?page=<%= curPage+1 %>" aria-label="Next">
          <span aria-hidden="true">&raquo;</span>
        </a>
      </li>
    </ul>
  </nav>
  <% } else { %>
  <div class="margin-t-elg m-row v-center" style="color: #666;">
    <h5>暂无内容</h5>
  </div>
  <% } %>
</div>

<script type="text/javascript" src="<%=basePath%>/bootstrap/js/bootstrap.bundle.js"></script>
</body>