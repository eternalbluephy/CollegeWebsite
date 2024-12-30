<%@ page import="com.etnvo1d.website.entity.Article" %>
<%@ page import="com.etnvo1d.website.dao.ArticleDAO" %>
<%@ page import="com.etnvo1d.website.util.DateUtil" %>
<%@ page import="com.etnvo1d.website.entity.Article" %>
<%@ page import="com.etnvo1d.website.entity.Question" %>
<%@ page import="com.etnvo1d.website.dao.QuestionDAO" %>
<%@ page import="com.etnvo1d.website.dao.AnswersDAO" %>
<%@ page import="com.etnvo1d.website.entity.Answer" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ include file="component/header.jsp"%>

<!DOCTYPE html>
<head>
    <meta charset="UTF-8">
    <base href="<%=basePath%>">
    <link rel="stylesheet" type="text/css" href="main.css">
    <link rel="stylesheet" type="text/css" href="<%=basePath%>/bootstrap/css/bootstrap.min.css">
    <title>咨询</title>
    <script type="text/javascript" src="<%=basePath%>/jquery.js"></script>

    <%
        String idStr = request.getParameter("id");
        if (idStr == null) {
            out.println("<script>alert('无效参数')</script>");
            return;
        }
        int id = Integer.parseInt(idStr);
        int curPage = request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page"));
        Question question = QuestionDAO.queryQuestion(id);
        if (question == null) {
            out.println("<script>alert('文章不存在')</script>");
            return;
        }
        int totalCount = AnswersDAO.countAnswers(id);
        int totalPages = (int) Math.ceil(totalCount / 12.0);
    %>
</head>

<body>
<%@include file="component/navbar.jsp"%>
<div class="container bg-white margin-t-lg" style="padding-top: 24px; padding-bottom: 24px;">
  <h2><%=question.getTitle()%></h2>
  <div class="mb-3">
    <small class="text-muted">
      发布者: <%=question.getAuthorName()%> |
      发布时间: <%=DateUtil.dateToString(question.getTime())%>
    </small>
  </div>
  <div class="mb-3 pb-4 border-bottom" style="color: #666"><%=question.getDescription()%></div>

  <div class="mb-4 border-bottom pb-4">
    <form>
      <input type="hidden" name="questionId" value="<%=id%>">
      <div class="form-group">
        <textarea class="form-control" id="content" name="content" rows="3" placeholder="写下你的回答" maxlength="1000" required></textarea>
      </div>
      <div class="mt-2 m-row v-end">
        <button type="button" class="btn btn-primary" onclick="if (confirm('确定要发布吗？')) submitAnswer(<%=question.getId()%>)">发布回答</button>
      </div>
    </form>
  </div>

  <h4>回答<sup class="ms-1"><%=totalCount%></sup></h4>
  <% if (totalCount > 0) { %>
  <div class="list-group list-group-flush">
    <% for (Answer answer : AnswersDAO.queryAnswersByPage(id, curPage)) { %>
      <div class="list-group-item py-3">
        <div class="d-flex justify-content-between">
          <span class="text-muted" style="font-size: 18px"><%=answer.getAuthorName()%></span>
          <small class="text-muted"><%=DateUtil.dateToString(answer.getTime())%></small>
        </div>
        <div class="mt-2"><%=answer.getContent()%></div>
      </div>
    <% } %>
  </div>
  <% } else { %>
    <div class="m-row v-center">
      <h5 style="color: #666">暂无评论</h5>
    </div>
  <% } %>

  <% if (totalPages > 1) { %>
  <nav aria-label="Page navigation" class="mt-4">
    <ul class="pagination justify-content-center">
      <li class="page-item <%= curPage <= 1 ? "disabled" : "" %>">
        <a class="page-link" href="question.jsp?id=<%=id%>&page=<%= curPage-1 %>" aria-label="Previous">
          <span aria-hidden="true">&laquo;</span>
        </a>
      </li>
      <% for(int i = 1; i <= totalPages; i++) { %>
      <li class="page-item <%= i == curPage ? "active" : "" %>">
        <a href="question.jsp?id=<%=id%>&page=<%=i%>" class="page-link <%= i == curPage ? "text-white" : "text-black"%>"><%= i %></a>
      </li>
      <% } %>
      <li class="page-item <%= curPage >= totalPages ? "disabled" : "" %>">
        <a class="page-link" href="question.jsp?id=<%=id%>&page=<%= curPage+1 %>" aria-label="Next">
          <span aria-hidden="true">&raquo;</span>
        </a>
      </li>
    </ul>
  </nav>
  <% } %>
</div>

<script type="text/javascript" src="<%=basePath%>/bootstrap/js/bootstrap.bundle.js"></script>
</body>

<script>
  function submitAnswer(id) {
      const content = $('#content').val();
      if (!content) {
          alert('请输入回答内容');
          return;
      }
      $.ajax({
          type: "post",
          url: "/api/submitComment",
          data: JSON.stringify({
              'id': id, 'content': content
          }),
          contentType: 'application/json',
          success: function (data) {
              if (data.success) {
                  window.location.reload();
                  alert("提交成功");
              } else {
                  alert(data.message);
              }
          },
          error: function(e) {
              console.error('Error:', e.responseText);
              alert('提交失败：' + e.responseText);
          }
      })
  }
</script>