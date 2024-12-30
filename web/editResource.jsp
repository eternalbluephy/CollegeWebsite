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
    <link rel="stylesheet" type="text/css" href="<%=basePath%>/wysiwyg/fontawesome/css/font-awesome.min.css"/>
    <title>编辑文章</title>
    <script type="text/javascript" src="<%=basePath%>/jquery.js"></script>
    <script type="text/javascript" src="<%=basePath%>/wysiwyg/bootstrap-wysiwyg/external/jquery.hotkeys.js"></script>
    <script type="text/javascript" src="<%=basePath%>/wysiwyg/bootstrap/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="<%=basePath%>/wysiwyg/bootstrap-wysiwyg/bootstrap-wysiwyg.js"></script>
</head>

<body>
<%@include file="component/navbar.jsp"%>
<%
    if ((int)session.getAttribute("type") != 1) {
        out.println("<script>alert('权限不足')</script>");
        return;
    }
    String idStr = request.getParameter("id");
    int id = 0;
    Resource resource = null;
    if (idStr != null) {
        id = Integer.parseInt(idStr);
        resource = ResourcesDAO.queryResource(id);
    }
%>
<div class="container margin-t-lg bg-white padding-x padding-y">
    <h3>资源编辑</h3>
    <form enctype="multipart/form-data" class="mt-4" id="resourceForm">
        <div class="row mb-3">
            <label for="title" class="col-sm-1 col-form-label">标题</label>
            <div class="col-sm-4">
                <input class="form-control" type="text" id="title" name="title" placeholder="请输入标题" value="<%=resource == null ? "" : resource.getTitle()%>" required />
            </div>
        </div>
        <div class="row mb-3">
            <label for="file" class="col-sm-1 col-form-label">文件</label>
            <div class="col-sm-4">
                <input class="form-control" type="file" id="file" name="file" />
            </div>
        </div>
        <div class="mb-1">
            <button class="btn btn-primary" type="button" onclick="if(confirm('确定提交吗？')) submitResource(<%=id%>, <%=resource == null%>)">提交</button>
        </div>
    </form>
</div>

<script type="text/javascript" src="<%=basePath%>/bootstrap/js/bootstrap.bundle.js"></script>
</body>

<script>
    function uploadFile(file) {
        const form = new FormData();
        form.append("file", $('#file')[0].files[0]);
        const xhr = new XMLHttpRequest();
        xhr.open("post", "/api/uploadFile", false);
        xhr.send(form);
        return xhr.responseText;
    }

    function submitResource(id, needRes) {
        const title = $('#title').val();
        if (!title) {
            alert('标题不能为空');
            return;
        }
        if (title.length > 30) {
            alert('标题长度不能大于30');
            return;
        }
        const resource = $('#file').val();
        if (needRes && !resource) {
            alert('文件不能为空');
            return;
        }
        let path = '';
        if (resource) path = uploadFile();
        const form = new FormData();
        form.append('id', id);
        form.append('title', title);
        form.append('path', path);
        console.log('here!');
        $.ajax({
            type: "post",
            url: "/api/postResource",
            data: form,
            async: false,
            contentType: false, // multipart
            processData: false,
            success: function (data) {
                if (data.success) {
                    window.location.href = "manageResources.jsp";
                    alert("提交成功");
                } else {
                    alert(data.message)
                }
            }
        });
    }

</script>