<%@ page import="com.etnvo1d.website.util.DateUtil" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="com.etnvo1d.website.dao.*" %>
<%@ page import="com.etnvo1d.website.entity.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ include file="component/header.jsp"%>

<!DOCTYPE html>
<head>
  <meta charset="UTF-8">
  <base href="<%=basePath%>">
  <link rel="stylesheet" type="text/css" href="main.css">
  <link rel="stylesheet" type="text/css" href="<%=basePath%>/bootstrap/css/bootstrap.min.css">
  <link rel="stylesheet" type="text/css" href="<%=basePath%>/wysiwyg/fontawesome/css/font-awesome.min.css"/>
  <title>图书借阅</title>
  <script type="text/javascript" src="<%=basePath%>/jquery.js"></script>
  <script type="text/javascript" src="<%=basePath%>/wysiwyg/bootstrap-wysiwyg/external/jquery.hotkeys.js"></script>
  <script type="text/javascript" src="<%=basePath%>/wysiwyg/bootstrap/js/bootstrap.min.js"></script>
  <script type="text/javascript" src="<%=basePath%>/wysiwyg/bootstrap-wysiwyg/bootstrap-wysiwyg.js"></script>
</head>

<body>
<%@include file="component/navbar.jsp"%>
<%
  if (!(boolean)session.getAttribute("login")) {
    out.println("<script>alert('权限不足')</script>");
    return;
  }
  String uid = (String)session.getAttribute("uid");
  String startDateStr = request.getParameter("startDate");
  String endDateStr = request.getParameter("endDate");
  if (startDateStr == null) startDateStr = "1970-01-01";
  if (endDateStr == null) endDateStr = LocalDate.now().toString();
  LocalDate startDate = DateUtil.stringToDate(startDateStr);
  LocalDate endDate = DateUtil.stringToDate(endDateStr);
  User user = UserDAO.queryUser(uid);
  int curPage = request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page"));
  int totalCount = RentsDAO.countRentByTimeRange(uid, startDate, endDate);
  int totalPages = (int)Math.ceil(totalCount / 12.0);
  int rentingCount = RentsDAO.countRentByState(uid, 0);
%>
<div class="container margin-t-lg">
  <div class="row mb-4">
    <div class="col-md-6">
      <div class="card">
        <div class="card-body">
          <h5 class="card-title">借阅统计</h5>
          <div class="m-row">
            <span class="card-text">当前借阅：</span>
            <h2 class="text-success"><%=rentingCount%></h2>
            <span class="card-text"> 本</span>
          </div>
          <div class="m-row">
            <span class="card-text">总借阅量：</span>
            <h2 class="text-primary"><%=totalCount%></h2>
            <span class="card-text"> 本</span>
          </div>
        </div>
      </div>
    </div>
  </div>
  <div class="card mt-4">
    <div class="card-body">
      <form class="mb-3">
        <div class="row">
          <div class="col-md-4">
            <input type="date" class="form-control" name="startDate" value="<%=startDateStr%>">
          </div>
          <div class="col-md-4">
            <input type="date" class="form-control" name="endDate" value="<%=endDateStr%>">
          </div>
          <div class="col-md-4">
            <button type="submit" class="btn btn-primary">查询</button>
          </div>
        </div>
      </form>

      <table class="table">
        <thead>
        <tr>
          <th>书名</th>
          <th>借阅时间</th>
          <th>状态</th>
        </tr>
        </thead>
        <tbody>
        <% for(Rent rent : RentsDAO.queryRentByTimeRange(uid, startDate, endDate, curPage)) { %>
        <tr>
          <td><%= rent.getName() %></td>
          <td><%= rent.getTime() %></td>
          <td><%= rent.getState() == 0 ? "借阅中": "已归还" %></td>
        </tr>
        <% } %>
        </tbody>
      </table>

      <nav aria-label="Page navigation" class="mt-4">
        <ul class="pagination justify-content-center">
          <li class="page-item <%= curPage <= 1 ? "disabled" : "" %>">
            <a class="page-link" href="rent.jsp?page=<%=curPage - 1%>&startDate=<%=startDateStr%>&endDate=<%=endDateStr%>" aria-label="Previous">
              <span aria-hidden="true">&laquo;</span>
            </a>
          </li>
          <% for(int i = 1; i <= totalPages; i++) { %>
          <li class="page-item <%= i == curPage ? "active" : "" %>">
            <a href="rent.jsp?page=<%=i%>&startDate=<%=startDateStr%>&endDate=<%=endDateStr%>" class="page-link <%= i == curPage ? "text-white" : "text-black"%>"><%= i %></a>
          </li>
          <% } %>
          <li class="page-item <%= curPage >= totalPages ? "disabled" : "" %>">
            <a class="page-link" href="rent.jsp?page=<%=curPage + 1%>&startDate=<%=startDateStr%>&endDate=<%=endDateStr%>" aria-label="Next">
              <span aria-hidden="true">&raquo;</span>
            </a>
          </li>
        </ul>
      </nav>
    </div>
  </div>
</div>
<script type="text/javascript" src="<%=basePath%>/bootstrap/js/bootstrap.bundle.js"></script>
</body>