<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.entities.User" %>
<%@ page import="com.entities.Action" %>
<%@ page import="com.database.ActionDao" %>
<%@ page import="com.entities.BookRecord" %>
<%@ page import="com.database.BookRecordDao" %>
<%@ page import="com.entities.Book" %>

<html>
<link rel="stylesheet" href="../style/user_avatar.css">
<link rel="stylesheet" href="../style/custom_table.css">

<head>
<title>用户业务</title>
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
        <h2>用户业务</h2>
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

    <div class="custom-table-container">
        <table class="custom-table">
            <thead>
                <tr>
                    <th>图书ID</th>
                    <th>图书标题</th>
                    <th>状态</th>
                    <th>借书日期</th>
                    <th>还书日期</th>
                    <th>操作</th>
                </tr>
            </thead>
            <%
                List<BookRecord> bookRecords = BookRecordDao.loadAllRecord();
            %>
            <tbody>
                <%
                    for (BookRecord bookRecord : bookRecords) {
                        Book book = bookRecord.book;
                %>
                    <tr>
                        <td><%= bookRecord.book.id %></td>
                        <td><%= bookRecord.book.name %></td>
                        <td><%= bookRecord.book.getFlagDisplay()%></td>
                        <td><%= bookRecord.startDate%></td>
                        <td><%= bookRecord.endDate%></td>
                        <td>
                        <%
                            if (book.flag == Book.LOST) {
                        %>
                            <button>a</button>
                        <%
                            } else if (book.flag == Book.BROKEN) {
                        %>
                            <button>b</button>
                        <%
                            } else {
                        %>
                            <button>c</button>
                        <%
                            }
                        %>
                        </td>
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
