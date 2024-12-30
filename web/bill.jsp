<%@ page import="java.util.List" %>
<%@ page import="com.etnvo1d.website.dao.ArticleDAO" %>
<%@ page import="com.etnvo1d.website.util.DateUtil" %>
<%@ page import="com.etnvo1d.website.entity.Article" %>
<%@ page import="com.etnvo1d.website.entity.Question" %>
<%@ page import="com.etnvo1d.website.dao.QuestionDAO" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="com.etnvo1d.website.dao.UserDAO" %>
<%@ page import="com.etnvo1d.website.entity.Bill" %>
<%@ page import="com.etnvo1d.website.entity.User" %>
<%@ page import="com.etnvo1d.website.dao.BillsDAO" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="java.time.LocalDate" %>
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
  <title>一卡通</title>
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
  LocalDateTime startDate = DateUtil.localDateToDateTime(DateUtil.stringToDate(startDateStr));
  LocalDateTime endDate = DateUtil.localDateToDateTime(DateUtil.stringToDate(endDateStr));
  User user = UserDAO.queryUser(uid);
  int curPage = request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page"));
  int totalCount = BillsDAO.countBillsByTimeRange(uid, startDate, endDate);
  int totalPages = (int)Math.ceil(totalCount / 12.0);
%>
<div class="container margin-t-lg">
</div>
<div class="container">
  <div class="card">
    <div class="card-body">
      <h4 class="card-title">一卡通余额</h4>
      <h2 class="text-primary">¥ <%= String.format("%.2f", user.getMoney()) %></h2>
    </div>
  </div>

  <div class="card mt-4">
    <div class="card-body">
      <h4 class="card-title">交易记录</h4>
      <form class="mb-3">
        <div class="row">
          <div class="col-md-4">
            <input type="date" name="startDate" class="form-control" value="<%= startDateStr %>">
          </div>
          <div class="col-md-4">
            <input type="date" name="endDate" class="form-control" value="<%= endDateStr %>">
          </div>
          <div class="col-md-4">
            <button type="submit" class="btn btn-primary">查询</button>
          </div>
        </div>
      </form>

      <table class="table">
        <thead>
          <tr>
            <th>时间</th>
            <th>金额</th>
            <th>类型</th>
          </tr>
        </thead>
        <tbody>
          <% for(Bill bill : BillsDAO.queryBillsByTimeRange(uid, startDate, endDate, curPage)) { %>
          <tr>
            <td><%= DateUtil.dateTimeToString(bill.getTime()) %></td>
            <td class="<%= bill.getValue() > 0 ? "text-success" : "text-danger" %>">
              <%= String.format("%.2f", bill.getValue()) %>
            </td>
            <td><%= bill.getValue() > 0 ? "充值" : "消费" %></td>
          </tr>
          <% } %>
        </tbody>
      </table>
    </div>
  </div>

  <nav aria-label="Page navigation" class="mt-4">
    <ul class="pagination justify-content-center">
      <li class="page-item <%= curPage <= 1 ? "disabled" : "" %>">
        <a class="page-link" href="bill.jsp?page=<%=curPage - 1%>&startDate=<%=startDateStr%>&endDate=<%=endDateStr%>" aria-label="Previous">
          <span aria-hidden="true">&laquo;</span>
        </a>
      </li>
      <% for(int i = 1; i <= totalPages; i++) { %>
      <li class="page-item <%= i == curPage ? "active" : "" %>">
        <a href="bill.jsp?page=<%=i%>&startDate=<%=startDateStr%>&endDate=<%=endDateStr%>" class="page-link <%= i == curPage ? "text-white" : "text-black"%>"><%= i %></a>
      </li>
      <% } %>
      <li class="page-item <%= curPage >= totalPages ? "disabled" : "" %>">
        <a class="page-link" href="bill.jsp?page=<%=curPage + 1%>&startDate=<%=startDateStr%>&endDate=<%=endDateStr%>" aria-label="Next">
          <span aria-hidden="true">&raquo;</span>
        </a>
      </li>
    </ul>
  </nav>
</div>
<script type="text/javascript" src="<%=basePath%>/bootstrap/js/bootstrap.bundle.js"></script>
</body>