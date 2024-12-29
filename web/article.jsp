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
        String idStr = request.getParameter("id");
        if (idStr == null) {
            out.println("<script>alert('无效参数')</script>");
            return;
        }
        int id = Integer.parseInt(idStr);
        Article article = ArticleDAO.getArticleDetail(id);
        if (article == null) {
            out.println("<script>alert('文章不存在')</script>");
            return;
        }
    %>
</head>

<body>
<%@include file="component/navbar.jsp"%>
<div class="container bg-white margin-t-lg" style="padding-top: 24px; padding-bottom: 24px;">
    <div class="d-flex flex-column align-items-center">
        <h4 class="text-center mb-3"><%=article.getTitle()%></h4>
        <div class="text-muted mb-4">
            <span class="text-weak">发布时间：<%=DateUtil.dateToString(article.getTime())%></span>
            <span class="text-weak">浏览次数：<%=article.getViews()%></span>
        </div>
        <div class="w-75" style="overflow: hidden;">
            <%=article.getContent()%>
        </div>
    </div>
</div>

<script type="text/javascript" src="<%=basePath%>/bootstrap/js/bootstrap.bundle.js"></script>
</body>