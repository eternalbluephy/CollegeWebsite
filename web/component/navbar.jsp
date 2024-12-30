<%@include file="loginControl.jsp"%>
<%
    boolean login = (boolean) session.getAttribute("login");
%>
<nav class="navbar navbar-expand-lg bg-white split-b border-bottom">
    <div class="container">
        <a class="navbar-brand" href="#">计算机科学与技术学院</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav"
                aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav me-auto">
                <li class="nav-item dropdown"><a class="nav-link dropdown-toggle" href="articles.jsp?type=1" role="button"
                                                 data-bs-toggle="dropdown">学院概况</a>
                    <ul class="dropdown-menu">
                        <li><a class="dropdown-item" href="article.jsp?id=20">学院简介</a></li>
                        <li><a class="dropdown-item" href="article.jsp?id=21">机构设置</a></li>
                        <li><a class="dropdown-item" href="article.jsp?id=22">师资队伍</a></li>
                        <li><a class="dropdown-item" href="article.jsp?id=27">学院领导</a></li>
                    </ul>
                </li>
                <li class="nav-item"><a class="nav-link" href="news.jsp">新闻动态</a></li>
                <li class="nav-item"><a class="nav-link" href="articles.jsp?type=2">学科建设</a></li>
                <li class="nav-item"><a class="nav-link" href="articles.jsp?type=3">招生就业</a></li>
                <li class="nav-item dropdown"><span class="nav-link dropdown-toggle" role="button"
                                                 data-bs-toggle="dropdown">公共服务</span>
                    <ul class="dropdown-menu">
                        <% if (login) { %>
                        <li><a class="dropdown-item" href="bill.jsp">校园一卡通</a></li>
                        <li><a class="dropdown-item" href="rent.jsp">图书借阅</a></li>
                        <% } %>
                        <li><a class="dropdown-item" href="article.jsp?id=25">校车时刻表</a></li>
                        <li><a class="dropdown-item" href="article.jsp?id=26">校园地图</a></li>
                    </ul>
                </li>
                <li class="nav-item"><a class="nav-link" href="resources.jsp">资源下载</a></li>
                <li class="nav-item"><a class="nav-link" href="questions.jsp">在线咨询</a></li>
            </ul>

            <div class="d-lg-none border-top mt-3 pt-3">
                <% if (!login) { %>
                <a href="${pageContext.request.contextPath}/login.jsp">
                    <button class="btn btn-primary w-100">登录</button>
                </a>
                <% } else { %>
                <% if (session.getAttribute("type") != null && ((int)session.getAttribute("type")) == 1) { %>
                    <a class="margin-b" href="manage.jsp">管理</a>
                <% } %>
                <div class="d-flex align-items-center gap-2 px-2">
                    <img src="<%=basePath%>assets/images/avatar.jpg" alt="用户头像" class="rounded-circle" width="32" height="32">
                    <div class="flex-grow-1">
                        <div class="fw-bold">用户名</div>
                        <div class="small text-muted">查看个人信息</div>
                    </div>
                </div>
                <div class="list-group mt-2">
                    <a class="list-group-item list-group-item-action text-danger" onclick="quit()">退出登录</a>
                </div>
                <% } %>
            </div>

            <div class="d-none d-lg-flex navbar-nav">
                <% if (!login) { %>
                <a href="${pageContext.request.contextPath}/login.jsp">
                    <button class="btn btn-primary">登录</button>
                </a>
                <% } else { %>
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown">
                        <img src="<%=basePath%>assets/images/avatar.jpg" alt="用户头像" class="rounded-circle" width="32" height="32">
                    </a>
                    <ul class="dropdown-menu dropdown-menu-end">
                        <% if (session.getAttribute("type") != null && ((int)session.getAttribute("type")) == 1) { %>
                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/manage.jsp">管理</a></li>
                        <li>
                            <hr class="dropdown-divider">
                        </li>
                        <% } %>
                        <li><a class="dropdown-item text-danger" onclick="quit()">退出登录</a></li>
                    </ul>
                </li>
                <% } %>
            </div>
        </div>
    </div>
</nav>

<script>
    function quit() {
        document.cookie = "token=;";
        window.location.href = "home.jsp";
    }
</script>