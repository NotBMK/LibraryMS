
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.entities.User" %>
<%@ page import="com.entities.Action" %>
<%@ page import="com.database.ActionDao" %>

<html>
<link rel="stylesheet" href="../style/user_avatar.css">
<link rel="stylesheet" href="../style/action_info_table.css">

<head>
    <title>图书馆管理系统操作日志</title>
</head>
<body>

<% if (session.getAttribute("username") == null) { %>
<script>
    alert('您尚未登录，请先登录！');
    window.location.href='<%= request.getContextPath() %>/login.jsp';
</script>
<% return; } %>

<%-- 添加 alert 消息提示 --%>
<% if (request.getSession().getAttribute("successMsg") != null) { %>
<script>
    alert('<%= request.getSession().getAttribute("successMsg") %>');
    <% request.getSession().removeAttribute("successMsg"); %>
</script>
<% } %>

<% if (request.getSession().getAttribute("errorMsg") != null) { %>
<script>
    alert('<%= request.getSession().getAttribute("errorMsg") %>');
    <% request.getSession().removeAttribute("errorMsg"); %>
</script>
<% } %>

<div class="container">
    <div class="header">
        <h2>图书馆管理系统操作日志</h2>
        <div class="user-area">
            <div class="user-circle" style="padding-right: 0">
                <%= session.getAttribute("username").toString().substring(0, 1) %>
            </div>
            <div class="user-menu">
                <a href="<%= request.getContextPath() %>/admin/adminInfo">个人信息</a>
                <a href="changePassword.jsp">修改密码</a>
                <a href="<%= request.getContextPath() %>/logout">退出登录</a>
            </div>
        </div>
    </div>

    <div class="action-list">
        <table class="action-table">
            <thead>
                <tr>
                    <th>操作类型</th>
                    <th>操作用户</th>
                    <th>操作书籍</th>
                    <th>操作时间</th>
                    <th>截止时间</th>
                    <th>备注</th>
                </tr>
            </thead>
            <tbody>
            <%
                List<Action> actions = ActionDao.loadAllAction();
                for (Action act : actions) {
            %>
                <tr>
                    <td><%= act.actType.toString() %></td>
                    <td><%= act.userId %></td>
                    <td><%= act.bookId %></td>
                    <td><%= act.actDate.toString() %></td>
                    <td><%= act.endDate.toString() %></td>
                    <td><%= act.comment %></td>
                </tr>
            <%
                }
            %>
            </tbody>

        </table>
    </div>

    <div style="margin-top: 20px;">
        <button onclick="window.location.href='home.jsp'" class="btn back-btn">返回主页</button>
    </div>
</div>

</body>
</html>
