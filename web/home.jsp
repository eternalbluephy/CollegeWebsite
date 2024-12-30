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
        List<Article> newsList = ArticleDAO.queryArticleHead(6, 0);
        List<Article> employList = ArticleDAO.queryArticleHead(6, 3);
        List<Question> questionList = QuestionDAO.queryQuestionHead(6);
    %>
</head>

<body>
<%@include file="component/navbar.jsp"%>
<div class="container pb-4">
    <div style="height: 12px"></div>
    <%@include file="component/carousel.html"%>
    <div class="m-row margin-t-lg spacebetween">
        <h2>新闻动态</h2>
        <a class="text-weak " href="${pageContext.request.contextPath}/news.jsp">查看全部</a>
    </div>
    <div class="m-row margin-t bg-white padding-y padding-x" style="align-items: flex-start; height: 250px;">
        <div class="mxh">
            <%
                for(Article article : newsList) {
            %>
            <div class="article-item padding-y-sm border-bottom article-area">
                <a class="text-truncate text-nowrap d-block" href="${pageContext.request.contextPath}/article.jsp?id=<%=article.getId()%>">
                    <%= article.getTitle() %>
                </a>
                <span class="text-secondary margin-l text-nowrap d-block">
                    <%= DateUtil.dateToString(article.getTime()) %>
                </span>
            </div>
            <%
                }
            %>
        </div>
        <%
            Article firstArticle = newsList.isEmpty() ? null : newsList.get(0);
            Article secondArticle = newsList.size() <= 1 ? null : newsList.get(1);
            if (firstArticle != null) {
        %>
        <div class="m-col d-none d-lg-block ms-4">
            <img src="<%=firstArticle.getCover()%>" style="width: 350px; height: 200px;" />
            <a href="article.jsp?id=<%=firstArticle.getId()%>" class="text-secondary text-nowrap text-truncate d-inline-block" style="max-width: 350px">
                <%=firstArticle.getTitle()%>
            </a>
        </div>
        <% } if (secondArticle != null) { %>
        <div class="m-col d-none d-xxl-block ms-4">
            <div class="col">
                <img src="<%=secondArticle.getCover()%>" style="width: 350px; height: 200px;" />
            </div>
            <div class="col">
                <a href="article.jsp?id=<%=secondArticle.getId()%>" class="text-secondary text-nowrap text-truncate d-inline-block" style="max-width: 350px">
                    <%=secondArticle.getTitle()%>
                </a>
            </div>
        </div>
        <% } %>
    </div>

    <div class="margin-t-lg list-lg">
        <div class="list-item-lg mxw">
            <div class="m-row spacebetween">
                <h2>招生就业</h2>
                <a class="text-weak" href="articles.jsp?type=3">查看全部</a>
            </div>
            <div class="m-row margin-t bg-white padding-y padding-x" style="align-items: flex-start; height: 250px;">
                <div class="mxh mxw">
                    <%
                        for(Article article : employList) {
                    %>
                    <div class="article-item padding-y-sm border-bottom">
                        <a href="${pageContext.request.contextPath}/article.jsp?id=<%=article.getId()%>" class="text-truncate d-inline-block">
                            <%= article.getTitle() %>
                        </a>
                        <span class="text-secondary margin-l text-nowrap">
                    <%= DateUtil.dateToString(article.getTime()) %>
                </span>
                    </div>
                    <%
                        }
                    %>
                </div>
            </div>
        </div>
        <div class="list-item-lg mxw">
            <div class="m-row spacebetween">
                <h2>在线咨询</h2>
                <a class="text-weak" href="articles.jsp?type=3">查看全部</a>
            </div>
            <div class="m-row margin-t bg-white padding-y padding-x" style="align-items: flex-start; height: 250px;">
                <div class="mxh mxw">
                    <%
                        for(Question question : questionList) {
                    %>
                    <div class="article-item padding-y-sm border-bottom">
                        <a href="#" class="text-truncate d-inline-block article-area">
                            <%= question.getTitle() %>
                        </a>
                        <span class="text-secondary margin-l text-nowrap">
                    <%= DateUtil.dateToString(question.getTime()) %>
                </span>
                    </div>
                    <%
                        }
                    %>
                </div>
            </div>
        </div>
    </div>
</div>

<script type="text/javascript" src="<%=basePath%>/bootstrap/js/bootstrap.bundle.js"></script>
</body>

<style>
    .article-item {
        display: flex;
        flex-direction: row;
        align-items: center;
        justify-content: space-between;
    }

    .article-area {
        width: 100%;
        display: flex;
        flex-wrap: wrap;
        align-items: center;
        justify-content: space-between;
    }

    .article-area a {
        flex: 1;
        min-width: 0;
        overflow: hidden;
        text-overflow: ellipsis;
        white-space: nowrap;
    }

    .article-area .text-secondary {
        flex-shrink: 0;
        margin-left: 1rem;
    }

    @media(min-width: 992px) {
        .article-area {
            width: auto;
            max-width: 520px;
        }
    }
</style>