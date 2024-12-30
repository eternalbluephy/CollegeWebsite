<%@ page import="com.etnvo1d.website.entity.Article" %>
<%@ page import="java.util.List" %>
<%@ page import="com.etnvo1d.website.dao.ArticleDAO" %>
<%@ page import="com.etnvo1d.website.util.DateUtil" %>
<%@ page import="com.etnvo1d.website.entity.Article" %>
<%@ page import="com.etnvo1d.website.entity.Question" %>
<%@ page import="com.etnvo1d.website.dao.QuestionDAO" %>
<%@ page import="java.util.HashMap" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ include file="component/header.jsp"%>

<!DOCTYPE html>
<head>
  <meta charset="UTF-8">
  <base href="<%=basePath%>">
  <link rel="stylesheet" type="text/css" href="main.css">
  <link rel="stylesheet" type="text/css" href="<%=basePath%>/bootstrap/css/bootstrap.min.css">
<%--  <link rel="stylesheet" type="text/css" href="<%=basePath%>/wysiwyg/bootstrap/css/bootstrap.min.css"/>--%>
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
  Article article = null;
  int type = 0;
  if (idStr != null) {
    id = Integer.parseInt(idStr);
    article = ArticleDAO.getArticleDetail(id);
  }
  if (article == null && request.getParameter("type") != null) {
    type = Integer.parseInt(request.getParameter("type"));
  }
  if (article != null) {
    type = article.getType();
  }
%>
<div class="container margin-t-lg">
  <form id="form-title">
    <div class="form-group row mb-3">
      <label for="title" class="col-sm-1 col-form-label">标题</label>
      <div class="col-sm-3">
        <input type="text" class="form-control" id="title" name="title" value="<%= article != null ? article.getTitle() : "" %>">
      </div>
    </div>
  </form>
  <form id="form-cover">
    <div class="form-group row mb-3">
      <label for="cover" class="col-sm-1 col-form-label">封面图片</label>
      <div class="col-sm-3">
        <%
          if (article != null) {
        %>
        <img src="<%=article.getCover()%>" />
        <% } %>
        <input type="file" class="form-control <%=article == null ? "" : "margin-t"%>" id="cover" name="cover" accept="image/*">
      </div>
    </div>
  </form>
  <div class="form-group">
    <span>编辑文章</span>
    <div class="col-sm-12">
      <input type="hidden" id="content" name="content">
      <div class="editor-container">
        <div class="btn-toolbar" role="toolbar" data-role="editor-toolbar"
             data-target="#editor">
          <div class="btn-group" role="group">
            <button type="button" class="btn dropdown-toggle"
                    data-toggle="dropdown" title="Font">
              <i class="icon-font"></i><b class="caret"></b>
            </button>
            <ul class="dropdown-menu">
            </ul>
          </div>
          <div class="btn-group" role="group">
            <button type="button" class="btn dropdown-toggle"
                    data-toggle="dropdown" title="Font Size">
              <i class="icon-text-height"></i>&nbsp;<b class="caret"></b>
            </button>
            <ul class="dropdown-menu">
              <li><a data-edit="fontSize 5"><font size="5">Huge</font></a></li>
              <li><a data-edit="fontSize 3"><font size="3">Normal</font></a></li>
              <li><a data-edit="fontSize 1"><font size="1">Small</font></a></li>
            </ul>
          </div>
          <div class="btn-group" role="group">
            <button type="button" class="btn" data-edit="bold"
                    title="Bold (Ctrl/Cmd+B)">
              <i class="icon-bold"></i>
            </button>
            <button type="button" class="btn" data-edit="italic"
                    title="Italic (Ctrl/Cmd+I)">
              <i class="icon-italic"></i>
            </button>
            <button type="button" class="btn" data-edit="strikethrough"
                    title="Strikethrough">
              <i class="icon-strikethrough"></i>
            </button>
            <button type="button" class="btn" data-edit="underline"
                    title="Underline (Ctrl/Cmd+U)">
              <i class="icon-underline"></i>
            </button>
          </div>
          <div class="btn-group" role="group">
            <button type="button" class="btn" data-edit="insertunorderedlist"
                    title="Bullet list">
              <i class="icon-list-ul"></i>
            </button>
            <button type="button" class="btn" data-edit="insertorderedlist"
                    title="Number list">
              <i class="icon-list-ol"></i>
            </button>
            <button type="button" class="btn" data-edit="outdent"
                    title="Reduce indent (Shift+Tab)">
              <i class="icon-indent-left"></i>
            </button>
            <button type="button" class="btn" data-edit="indent"
                    title="Indent (Tab)">
              <i class="icon-indent-right"></i>
            </button>
          </div>
          <div class="btn-group" role="group">
            <button type="button" class="btn" data-edit="justifyleft"
                    title="Align Left (Ctrl/Cmd+L)">
              <i class="icon-align-left"></i>
            </button>
            <button type="button" class="btn" data-edit="justifycenter"
                    title="Center (Ctrl/Cmd+E)">
              <i class="icon-align-center"></i>
            </button>
            <button type="button" class="btn" data-edit="justifyright"
                    title="Align Right (Ctrl/Cmd+R)">
              <i class="icon-align-right"></i>
            </button>
            <button type="button" class="btn" data-edit="justifyfull"
                    title="Justify (Ctrl/Cmd+J)">
              <i class="icon-align-justify"></i>
            </button>
          </div>
          <div class="btn-group" role="group">
            <div class="btn-group" role="group">
              <button type="button" class="btn dropdown-toggle"
                      data-toggle="dropdown" title="Hyperlink">
                <i class="icon-link"></i>
              </button>
              <div class="dropdown-menu">
                <div class="input-group" style="margin: 0 5px; min-width: 200px;">
                  <input class="form-control" placeholder="URL" type="text"
                         data-edit="createLink"/> <span class="input-group-btn">
								<button class="btn" type="button">Add</button>
							</span>
                </div>
              </div>
            </div>
            <button type="button" class="btn" data-edit="unlink"
                    title="Remove Hyperlink">
              <i class="icon-cut"></i>
            </button>
          </div>
          <div class="btn-group" role="group">
            <button type="button" class="btn"
                    title="Insert picture (or just drag & drop)" id="pictureBtn">
              <i class="icon-picture"></i>
            </button>
            <input type="file" data-role="magic-overlay"
                   data-target="#pictureBtn" data-edit="insertImage"/>
          </div>
          <div class="btn-group" role="group">
            <button type="button" class="btn" data-edit="undo"
                    title="Undo (Ctrl/Cmd+Z)">
              <i class="icon-undo"></i>
            </button>
            <button type="button" class="btn" data-edit="redo"
                    title="Redo (Ctrl/Cmd+Y)">
              <i class="icon-repeat"></i>
            </button>
          </div>
        </div>
        <div id="editor">
          <%
            if (article != null) {
          %>
          <%=article.getContent()%>
          <% } %>
        </div>
      </div>
      <button class="btn btn-primary" onclick="addActivity(<%=id%>, <%=type%>, <%=type==0 && article==null%>)">提交</button>
    </div>
  </div>
</div>

<script type="text/javascript" src="<%=basePath%>/bootstrap/js/bootstrap.bundle.js"></script>
</body>

<script>
  $(function() {
    // 初始化工具条
    initToolbarBootstrapBindings();
    $('#editor').wysiwyg();
  });

  function initToolbarBootstrapBindings() {
    const fonts = ['Serif', 'Sans', 'Arial', 'Arial Black', 'Courier',
              'Courier New', 'Comic Sans MS', 'Helvetica', 'Impact',
              'Lucida Grande', 'Lucida Sans', 'Tahoma', 'Times',
              'Times New Roman', 'Verdana'],
            fontTarget = $('[title=Font]').siblings('.dropdown-menu');
    $.each(fonts,function(idx, fontName) {
      fontTarget.append($('<li><a href="#" data-edit="fontName ' + fontName
              +'" style="font-family:\''+ fontName +'\'">' + fontName + '</a></li>'));
    });

    $('button[title]').tooltip({
      container : 'body'
    });

    $('.dropdown-menu input').click(function() {
      return false;
    })
            .change(function() {
              $(this).parent('.dropdown-menu').siblings('.dropdown-toggle').dropdown('toggle');
            })
            .keydown('esc', function() {
              this.value = '';
              $(this).change();
            });

    $('[data-role=magic-overlay]').each(function() {
      const overlay = $(this), target = $(overlay.data('target'));
      overlay.css('opacity', 0).css('position', 'absolute')
              .offset(target.offset()).width(target.outerWidth())
              .height(target.outerHeight());
    });
  };

  function uploadCover() {
    const form = new FormData();
    form.append("editorImage", $('#cover')[0].files[0]);
    const xhr = new XMLHttpRequest();
    xhr.open("post", "/api/uploadImg.jsp", false);
    xhr.send(form);
    return xhr.responseText;
  }

  function addActivity(id, type, needCover) {
    // 标题
    const title = $("#title").val();
    if (!title) {
      alert("标题不能为空");
      return;
    }
    // 封面
    const cover = $("#cover").val();
    let coverUrl = "";
    if (cover) coverUrl = uploadCover();
    else if (needCover) {
      alert("封面不能为空");
      return;
    }
    // 内容
    const content = $("#editor").html();
    if (!content) {
      alert("内容不能为空");
      return;
    }
    // 合在一起
    const form = new FormData();
    form.append("id", id);
    form.append("title", title);
    form.append("cover", coverUrl);
    form.append("content", content);
    form.append("type", type);
    $.ajax({
      type: "post",
      url: "/api/postArticle",
      data: form,
      async: false,
      contentType: false, // multipart
      processData: false,
      success: function (data) {
        if (data.success) {
          window.location.href = "manage.jsp";
          alert("提交成功");
        } else {
          alert(data.message)
        }
      }
    });
  }
</script>

<style>
  .editor-container {
    padding: 10px 20px 25px;
    margin-bottom: 10px;
    background-color: #eeeeee;
    -webkit-border-radius: 6px;
    -moz-border-radius: 6px;
    border-radius: 6px;
  }

  .btn-toolbar {
    font-size: 0;
    margin-top: 10px;
    margin-bottom: 10px;
  }

  #editor {
    max-height: 400px;
    height: 400px;
    background-color: white;
    border-collapse: separate;
    border: 1px solid rgb(204, 204, 204);
    padding: 4px;/*高度*/
    box-sizing: content-box;
    -webkit-box-shadow: rgba(0, 0, 0, 0.0745098) 0px 1px 1px 0px inset;
    box-shadow: rgba(0, 0, 0, 0.0745098) 0px 1px 1px 0px inset;
    border-top-right-radius: 3px;
    border-bottom-right-radius: 3px;
    border-bottom-left-radius: 3px;
    border-top-left-radius: 3px;
    overflow: scroll;
    outline: none;
  }

  .btn-toolbar .btn {
    color: #333;
    background-color: #fff;
    border-color: #ccc;
  }

  .btn-toolbar .btn-info {
    color: #fff;
    background-color: #5bc0de;
    border-color: #46b8da;
  }
</style>