<%@ page import="java.util.List" %>
<%@ page import="com.etnvo1d.website.entity.Resource" %>
<%@ page import="com.etnvo1d.website.dao.ResourcesDAO" %>
<%@ page import="com.etnvo1d.website.entity.User" %>
<%@ page import="com.etnvo1d.website.dao.UserDAO" %>
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
  int curPage = request.getParameter("page") != null ? Integer.parseInt(request.getParameter("page")) : 1;
%>
<div class="container margin-t-lg">
  <div class="row">
    <div class="col-md-3">
      <div class="list-group">
        <a href="manage.jsp?type=0" class="list-group-item list-group-item-action">新闻动态</a>
        <a href="manage.jsp?type=1" class="list-group-item list-group-item-action">学院概况</a>
        <a href="manage.jsp?type=2" class="list-group-item list-group-item-action">学科建设</a>
        <a href="manage.jsp?type=3" class="list-group-item list-group-item-action">招生就业</a>
        <a href="manageResources.jsp" class="list-group-item list-group-item-action">资源下载</a>
        <a href="manageUser.jsp" class="list-group-item list-group-item-action active">用户管理</a>
      </div>
    </div>
    <div class="col-md-9 bg-white">
      <div class="d-flex justify-content-end">
        <button class="btn-primary btn margin-y" onclick="showAddUserModal()">新增</button>
      </div>
      <%
        List<User> users = UserDAO.queryUsersByPage(curPage);
        if (users.isEmpty()) {
          out.println("<p class='text-center mt-4'>暂无数据</p>");
        } else {
          int totalPages = (int) Math.ceil(UserDAO.countUsers() / 12.0);
      %>
      <table class="table">
        <thead>
        <tr>
          <th>ID</th>
          <th>姓名</th>
          <th>操作</th>
        </tr>
        </thead>
        <tbody>
        <% for(User user : users) { %>
        <tr>
          <td><%= user.getId() %></td>
          <td><%= user.getName() %></td>
          <td>
            <button class="btn btn-primary btn-sm" onclick="showEditUserModal(<%=user.getId()%>, '<%=user.getName()%>')">编辑</button>
            <button class="btn btn-danger btn-sm" onclick="if(confirm('确定删除?')) submitDelete(<%=user.getId()%>)">删除</button>
          </td>
        </tr>
        <% } %>
        </tbody>
      </table>
      <nav aria-label="Page navigation" class="mt-4">
        <ul class="pagination justify-content-center">
          <li class="page-item <%= curPage <= 1 ? "disabled" : "" %>">
            <a class="page-link" href="manageUser.jsp&page=<%= curPage-1 %>" aria-label="Previous">
              <span aria-hidden="true">&laquo;</span>
            </a>
          </li>
          <% for(int i = 1; i <= totalPages; i++) { %>
          <li class="page-item <%= i == curPage ? "active" : "" %>">
            <a href="manageUser.jsp&page=<%=i%>" class="page-link <%= i == curPage ? "text-white" : "text-black"%>"><%= i %></a>
          </li>
          <% } %>
          <li class="page-item <%= curPage >= totalPages ? "disabled" : "" %>">
            <a class="page-link" href="manageUser.jsp&page=<%= curPage+1 %>" aria-label="Next">
              <span aria-hidden="true">&raquo;</span>
            </a>
          </li>
        </ul>
      </nav>
      <% } %>
    </div>
  </div>
</div>

<div class="modal fade" id="userModal" tabindex="-1" aria-labelledby="userModal" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <h1 class="modal-title fs-5" id="userModalTitle"></h1>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body">
        <form>
          <div>
            <label for="id" class="col-form-label">ID</label>
            <input class="form-control" id="id" name="id" placeholder="请输入用户ID" required />
          </div>
          <div>
            <label for="name" class="col-form-label">姓名</label>
            <input class="form-control" id="name" name="name" placeholder="请输入用户姓名" required />
          </div>
          <div>
            <label for="password" class="col-form-label">密码</label>
            <input class="form-control" id="password" name="password" placeholder="请输入用户密码" />
          </div>
        </form>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">取消</button>
        <button type="button" class="btn btn-primary" onclick="submitUser()">提交</button>
      </div>
    </div>
  </div>
</div>

<script type="text/javascript" src="<%=basePath%>/bootstrap/js/bootstrap.bundle.js"></script>
</body>

<script>
    let update = false;

    function showAddUserModal() {
        update = false;
        $('#id').val('');
        $('#id').prop('disabled', false);
        $('#userModalTitle').text('新增用户');
        $('#name').val('');
        $('#userModal').modal('show');
    }

    function showEditUserModal(id, name) {
        update = true;
        $('#id').val(id);
        $('#id').prop('disabled', true);
        $('#userModalTitle').text('编辑用户');
        $('#name').val(name);
        $('#userModal').modal('show');
    }

    function submitUser() {
        const id = $('#id').val();
        const name = $('#name').val();
        const password = $('#password').val();
        if (!id && !password) {
            alert('密码不能为空');
            return;
        }
        if (!update && password.length < 6 || password.length > 12) {
            alert('密码长度必须在6到12之间');
            return;
        }
        data = { id: id, name: name, update: update };
        if (password) data.password = password;
        $.ajax({
            type: "post",
            url: "/api/postUser",
            data: data,
            success: function (data) {
                if (data.success) {
                    window.location.reload();
                    alert("提交成功");
                } else {
                    alert(data.message);
                }
            },
            error: function (e) {
                alert(e.responseText);
            }
        });
    }

    function submitDelete(id) {
        $.ajax({
            type: "post",
            url: "/api/removeUser",
            data: { id: id },
            success: function (data) {
                if (data.success) {
                    window.location.reload();
                    alert("删除成功");
                } else {
                    alert(data.message);
                }
            }
        });
    }
</script>

<style>
    .list-group-item-action.active {
        color: #fff !important;
    }
</style>