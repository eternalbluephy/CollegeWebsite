<%@ page import="java.util.List" %>
<%@ page import="com.etnvo1d.website.util.DateUtil" %>
<%@ page import="com.etnvo1d.website.dao.QuestionDAO" %>
<%@ page import="com.etnvo1d.website.entity.Question" %>
<%@ page import="com.etnvo1d.website.dao.AnswersDAO" %>
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
        int totalCount = QuestionDAO.countQuestions();
        int totalPages = (int) Math.ceil(totalCount / 12.0);
    %>
</head>

<body>
<%@include file="component/navbar.jsp"%>
<div class="container margin-t-lg">
    <div class="m-row spacebetween">
        <h3>在线咨询</h3>
        <div class="m-row">
            <span class="text-secondary me-3">共 <%=totalCount%> 条</span>
            <button class="btn btn-primary btn-sm" data-bs-toggle="modal" data-bs-target="#submitQuestionModal">发布提问</button>
        </div>
    </div>
    <div class="row margin-t">
        <%
            List<Question> questions = QuestionDAO.queryQuestionsByPage(curPage);
            for (Question question : questions) {
        %>
        <div class="col-12 mb-3">
            <div class="card">
                <div class="card-body">
                    <div class="m-row spacebetween">
                        <a href="question.jsp?id=<%=question.getId()%>">
                            <h5><%= question.getTitle() %></h5>
                        </a>
                        <span class="mb-2 text-secondary"><%= DateUtil.dateToString(question.getTime()) %></span>
                    </div>
                    <div class="m-row">
                        <span class="text-secondary me-3"><%=AnswersDAO.countAnswers(question.getId())%> 条回答</span>
                        <span class="text-secondary">由 <%=question.getAuthorName()%> 提问</span>
                    </div>
                </div>
            </div>
        </div>
        <% } %>
    </div>
    <nav aria-label="Page navigation" class="mt-4">
        <ul class="pagination justify-content-center">
            <li class="page-item <%= curPage <= 1 ? "disabled" : "" %>">
                <a class="page-link" href="questions.jsp?page=<%= curPage-1 %>" aria-label="Previous">
                    <span aria-hidden="true">&laquo;</span>
                </a>
            </li>
            <% for(int i = 1; i <= totalPages; i++) { %>
            <li class="page-item <%= i == curPage ? "active" : "" %>">
                <a href="questions.jsp?page=<%=i%>" class="page-link <%= i == curPage ? "text-white" : "text-black"%>"><%= i %></a>
            </li>
            <% } %>
            <li class="page-item <%= curPage >= totalPages ? "disabled" : "" %>">
                <a class="page-link" href="questions.jsp?page=<%= curPage+1 %>" aria-label="Next">
                    <span aria-hidden="true">&raquo;</span>
                </a>
            </li>
        </ul>
    </nav>
</div>

<div class="modal fade" id="submitQuestionModal" tabindex="-1" aria-labelledby="submitQuestionModal" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h1 class="modal-title fs-5" id="submitQuestionLabel">发布提问</h1>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form>
                    <div class="col">
                        <label for="title" class="col-form-label col-sm-1">问题</label>
                        <input maxlength="60" id="title" name="title" class="form-control col-sm-4" placeholder="请输入标题" required />
                    </div>
                    <div class="col">
                        <label for="description" class="col-form-label col-sm-1">描述</label>
                        <textarea maxlength="1000" id="description" name="title" class="form-control col-sm-3" rows="3" placeholder="请输入问题描述" required></textarea>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary btn-sm" data-bs-dismiss="modal">取消</button>
                <button type="button" class="btn btn-primary btn-sm" onclick="if (confirm('确定要提交吗？')) submitQuestion()">提交</button>
            </div>
        </div>
    </div>
</div>

<script type="text/javascript" src="<%=basePath%>/bootstrap/js/bootstrap.bundle.js"></script>
</body>

<script>
    function submitQuestion() {
        const title = $('#title').val();
        const description = $('#description').val();
        if (!title) {
            alert('请输入问题标题');
            return;
        }
        if (!description) {
            alert('请输入问题描述');
            return;
        }
        $.ajax({
            type: "post",
            url: "/api/submitQuestion",
            data: JSON.stringify({
                'title': title, 'description': description
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