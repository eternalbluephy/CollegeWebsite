<%@ page import="java.util.List" %>
<%@ page import="com.etnvo1d.website.util.DateUtil" %>
<%@ page import="com.etnvo1d.website.entity.Resource" %>
<%@ page import="com.etnvo1d.website.dao.ResourcesDAO" %>
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
        String pageStr = request.getParameter("page");
        int curPage = pageStr == null ? 1 : Integer.parseInt(pageStr);
        int totalCount = ResourcesDAO.countResources();
        int totalPages = (int) Math.ceil(totalCount / 12.0);
    %>
</head>

<body>
<%@include file="component/navbar.jsp"%>
<div class="container margin-t-lg">
    <div class="m-row spacebetween">
        <h3>资源下载</h3>
        <span class="text-secondary">共 <%=totalCount%> 条</span>
    </div>
    <div class="row margin-t">
        <%
            List<Resource> resources = ResourcesDAO.queryResourcesByPage(curPage);
            for (Resource resource : resources) {
        %>
        <div class="col-12 mb-3">
            <div class="card">
                <div class="card-body">
                    <div class="m-row spacebetween">
                        <a href="<%=resource.getPath()%>">
                            <h5><%= resource.getTitle() %></h5>
                        </a>
                        <span class="mb-2 text-secondary">下载 <%=resource.getDownloads()%> 次</span>
                    </div>
                    <span class="text-secondary"><%= DateUtil.dateToString(resource.getTime()) %></span>
                </div>
            </div>
        </div>
        <% } %>
    </div>
    <nav aria-label="Page navigation" class="mt-4">
        <ul class="pagination justify-content-center">
            <li class="page-item <%= curPage <= 1 ? "disabled" : "" %>">
                <a class="page-link" href="resources.jsp?page=<%= curPage-1 %>" aria-label="Previous">
                    <span aria-hidden="true">&laquo;</span>
                </a>
            </li>
            <% for(int i = 1; i <= totalPages; i++) { %>
            <li class="page-item <%= i == curPage ? "active" : "" %>">
                <span class="page-link text-white"><%= i %></span>
            </li>
            <% } %>
            <li class="page-item <%= curPage >= totalPages ? "disabled" : "" %>">
                <a class="page-link" href="resources.jsp?page=<%= curPage+1 %>" aria-label="Next">
                    <span aria-hidden="true">&raquo;</span>
                </a>
            </li>
        </ul>
    </nav>
</div>

<script type="text/javascript" src="<%=basePath%>/bootstrap/js/bootstrap.bundle.js"></script>
</body>