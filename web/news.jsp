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
  <title>计算机科学与技术学院</title>
  <script type="text/javascript" src="<%=basePath%>/jquery.js"></script>

  <%
    int newsPage = request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page"));
    int totalPage = ArticleDAO.countArticlePages(0);
  %>
</head>

<body>
<%@include file="component/navbar.jsp"%>
<div style="height: 12px"></div>
<div class="container">
  <div class="row row-cols-1 row-cols-md-2 row-cols-lg-3 g-4">
    <%
      List<Article> articles = ArticleDAO.queryArticlesByPage(newsPage, 0);
      for (Article article : articles) {
    %>
      <div class="col">
        <div class="card h-100">
          <img src="<%=article.getCover()%>" class="card-img-top" alt="News Cover" style="height: 200px;">
          <div class="card-body">
            <h5 class="card-title">
              <a href="${pageContext.request.contextPath}/article.jsp?id=<%=article.getId()%>" class="text">
                <%=article.getTitle()%>
              </a>
            </h5>
            <p class="text-secondary"><%=DateUtil.dateToString(article.getTime())%></p>
          </div>
        </div>
      </div>
    <%
      }
    %>
  </div>
  <nav aria-label="Page navigation" class="mt-4">
    <ul class="pagination justify-content-center">
      <li class="page-item <%= newsPage <= 1 ? "disabled" : "" %>">
        <a class="page-link" href="news.jsp?page=<%= newsPage-1 %>" aria-label="Previous">
          <span aria-hidden="true">&laquo;</span>
        </a>
      </li>
      <% for(int i = 1; i <= totalPage; i++) { %>
        <li class="page-item <%= i == newsPage ? "active" : "" %>">
          <span class="page-link text-white"><%= i %></span>
        </li>
      <% } %>
      <li class="page-item <%= newsPage >= totalPage ? "disabled" : "" %>">
        <a class="page-link" href="news.jsp?page=<%= newsPage+1 %>" aria-label="Next">
          <span aria-hidden="true">&raquo;</span>
        </a>
      </li>
    </ul>
  </nav>
</div>

<script type="text/javascript" src="<%=basePath%>/bootstrap/js/bootstrap.bundle.js"></script>
</body>