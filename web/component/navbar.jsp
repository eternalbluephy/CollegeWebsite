<%@include file="LoginControl.jsp"%>

<%
    boolean isLogined = session.getAttribute("isLogined") != null && (boolean) session.getAttribute("isLogined");
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
                <li class="nav-item dropdown"><a class="nav-link dropdown-toggle" href="#" role="button"
                                                 data-bs-toggle="dropdown">学院概况</a>
                    <ul class="dropdown-menu">
                        <li><a class="dropdown-item" href="#">学院简介</a></li>
                        <li><a class="dropdown-item" href="#">机构设置</a></li>
                        <li><a class="dropdown-item" href="#">师资队伍</a></li>
                    </ul>
                </li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/news.jsp">新闻动态</a></li>
                <li class="nav-item"><a class="nav-link" href="#">学科建设</a></li>
                <li class="nav-item"><a class="nav-link" href="#">招生就业</a></li>
                <li class="nav-item"><a class="nav-link" href="#">公共服务</a></li>
                <li class="nav-item"><a class="nav-link" href="#">资源下载</a></li>
                <li class="nav-item"><a class="nav-link" href="#">在线咨询</a></li>
            </ul>

            <!-- 用户状态区域 -->
            <div class="d-lg-none border-top mt-3 pt-3">
                <% if (!isLogined) { %>
                <a href="${pageContext.request.contextPath}/login.jsp">
                    <button class="btn btn-primary w-100">登录</button>
                </a>
                <% } else { %>
                <% if (session.getAttribute("type") != null && ((int)session.getAttribute("type")) == 1) { %>
                    <a class="margin-b" href="manage.jsp">管理</a>
                <% } %>
                <div class="d-flex align-items-center gap-2 px-2">
                    <img src="/assets/avatar.png" alt="用户头像" class="rounded-circle" width="32" height="32">
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

            <!-- 桌面端用户状态区域 -->
            <div class="d-none d-lg-flex navbar-nav">
                <% if (!isLogined) { %>
                <a href="${pageContext.request.contextPath}/login.jsp">
                    <button class="btn btn-primary">登录</button>
                </a>
                <% } else { %>
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown">
                        <img src="/assets/avatar.png" alt="用户头像" class="rounded-circle" width="32" height="32">
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
        localStorage.removeItem("jwt_token");
        window.location.href = "/";
    }
</script>