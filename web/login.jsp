<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ include file="component/header.jsp"%>

<!DOCTYPE html>
<head>
  <meta charset="UTF-8">
  <base href="<%=basePath%>">
  <link rel="stylesheet" type="text/css" href="main.css">
  <link rel="stylesheet" type="text/css" href="<%=basePath%>/bootstrap/css/bootstrap.min.css">
  <title>登录</title>
  <script type="text/javascript" src="<%=basePath%>/jquery.js"></script>
</head>
<body>

<%@include file="component/navbar.jsp"%>
<div class="container-fluid">
  <div class="row min-vh-100" style="margin-top: -56.57px;">
    <div class="col-12 d-flex align-items-center justify-content-center" style="padding-top: 56.57px;">
      <div class="card shadow-sm" style="min-width: 300px; max-width: 400px;">
        <div class="card-header text-center">
          <h4 class="my-2">用户登录</h4>
        </div>
        <div class="card-body p-4">
          <form method="post" id="loginForm">
            <div class="mb-3">
              <label for="id" class="form-label">用户名</label>
              <input type="text" class="form-control" id="id" name="id" placeholder="请输入用户名" required>
            </div>
            <div class="mb-3">
              <label for="password" class="form-label">密码</label>
              <input type="password" class="form-control" id="password" name="password" placeholder="请输入密码" required>
            </div>
            <div class="mb-3 form-check">
              <input type="checkbox" class="form-check-input" name="rememberMe" id="rememberMe">
              <label class="form-check-label" for="rememberMe">记住我</label>
            </div>
            <div class="d-grid">
              <button id="submitLoginBtn" type="submit" class="btn btn-primary">登录</button>
            </div>
          </form>
        </div>
      </div>
    </div>
  </div>
</div>

<script>
  $(document).ready(() => {
    $('#loginForm').on('submit', (e) => {
      e.preventDefault();
      const id = $('#id').val().trim();
      const password = $('#password').val().trim();
      if(!id || !password) {
        alert('用户名和密码不能为空');
        return false;
      }
      $.ajax({
        url: '<%=basePath%>/api/login.jsp',
        type: 'POST',
        data: {
          id: id,
          password: password,
          rememberMe: $('#rememberMe').is(':checked')
        },
        success: function(response) {
          console.log(response.success);
          if(response.success) {
            localStorage.setItem('jwt_token', response.token);
            window.location.href = '<%=basePath%>/index.jsp';
          } else {
            alert(response.message);
          }
        },
        error: function() {
          alert('登录失败，请重试');
        }
      });
    })
  })
</script>

<script type="text/javascript" src="<%=basePath%>/bootstrap/js/bootstrap.bundle.js"></script>
</body>