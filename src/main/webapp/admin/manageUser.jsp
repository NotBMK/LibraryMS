
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.entities.User" %>

<html>
<head>
    <title>用户管理</title>
    <link rel="stylesheet" href="../style/custom_table.css">
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
        }

        .container {
            width: 90%;
            margin: 30px auto;
            padding: 20px;
            background-color: white;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }

        h2 {
            text-align: center;
            color: #333;
        }

        .search-form {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            margin-bottom: 20px;
        }

        .search-form input[type="text"], .search-form select {
            padding: 8px;
            border: 1px solid #ccc;
            border-radius: 4px;
            width: calc(33% - 10px);
        }

        .search-form button {
            padding: 8px 15px;
            background-color: #2196F3;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }

        .search-form button:hover {
            background-color: #1976D2;
        }

        .user-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }

        .user-table th, .user-table td {
            padding: 12px;
            border: 1px solid #ddd;
            text-align: left;
            cursor: pointer;
        }

        .user-table tr:hover {
            background-color: #f1f1f1;
        }

        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .user-area {
            position: relative;
        }

        .user-circle {
            width: 60px;
            height: 60px;
            background-color: #2196F3;
            border-radius: 50%;
            display: flex;
            justify-content: center;
            align-items: center;
            color: white;
            font-size: 1.5em;
            cursor: pointer;
            z-index: 10;
        }

        .user-menu {
            display: none;
            position: absolute;
            right: 0;
            top: 70px;
            background-color: white;
            border-radius: 5px;
            box-shadow: 0 0 10px rgba(0,0,0,0.2);
            padding: 10px 0;
            width: 150px;
            z-index: 20;
        }

        .user-menu a {
            display: block;
            padding: 8px 15px;
            text-decoration: none;
            color: #333;
        }

        .user-menu a:hover {
            background-color: #f0f0f0;
        }

    </style>
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            const userCircle = document.querySelector('.user-circle');
            const userMenu = document.querySelector('.user-menu');

            userCircle.addEventListener('click', function () {
                userMenu.style.display = (userMenu.style.display === 'block') ? 'none' : 'block';
            });

            document.addEventListener('click', function (e) {
                if (!userCircle.contains(e.target) && !userMenu.contains(e.target)) {
                    userMenu.style.display = 'none';
                }
            });
        });
    </script>
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
        <h2>用户管理</h2>
        <div class="user-area">
            <div class="user-circle">
                <%= session.getAttribute("username").toString().substring(0, 1) %>
            </div>
            <div class="user-menu">
                <a href="<%= request.getContextPath() %>/admin/adminInfo">个人信息</a>
                <a href="changePassword.jsp">修改密码</a>
                <a href="<%= request.getContextPath() %>/logout">退出登录</a>
            </div>
        </div>
    </div>

    <form action="<%= request.getContextPath() %>/admin/searchUsers" method="post" class="search-form">
        <input type="text" name="userId" placeholder="用户ID">
        <input type="text" name="username" placeholder="用户名">
        <select name="gender">
            <option value="">性别</option>
            <option value="MALE">男</option>
            <option value="FEMALE">女</option>
            <option value="OTHER">其他</option>
        </select>
        <input type="text" name="comment" placeholder="备注信息">

        <button type="submit">搜索</button>


    </form>

    <div style="margin-bottom: 20px; text-align: left;">
        <button type="button" onclick="window.location.href='registerUser.jsp'" style="padding: 8px 15px; background-color: #4CAF50; color: white; border: none; border-radius: 4px; cursor: pointer;">
            新增用户
        </button>
    </div>


    <%-- 查询结果展示 --%>
    <table class="custom-table">
        <thead>
        <tr>
            <th>用户名</th>
            <th>性别</th>
            <th>用户类型</th>
            <th>借阅数量</th>
            <th>借阅期限</th>
            <th>备注信息</th>
            <th>操作</th> <%-- 新增操作列 --%>
        </tr>
        </thead>
        <tbody>
        <%
            List<User> users = (List<User>) request.getAttribute("users");
            if (users != null && !users.isEmpty()) {
                for (User user : users) {
        %>
        <tr>
            <td><%= user.getName() %></td>
            <td><%= user.getGenderDisplay() %></td>
            <td><%= user.getTypeDisplay() %></td>
            <td><%= user.getBookAmount() %></td>
            <td><%= user.getLoanPeriod() %> 天</td>
            <td><%= user.getComment() != null ? user.getComment() : "" %></td>
            <td style="white-space: nowrap;">
                <!-- 编辑按钮 -->
                <button class="btn edit-btn" onclick="window.location.href='adminEditUserInfo.jsp?userId=<%= user.getId() %>'">编辑</button>
                <!-- 删除按钮 -->
                <%--<button class="btn delete-btn" onclick="if(confirm('确定要删除该用户吗？')) window.location.href='deleteUser.jsp?userId=<%= user.getId() %>'">删除</button> --%>
            </td>
        </tr>
        <%
            }
        } else {
        %>
        <tr>
            <td colspan="7" style="text-align:center;">暂无用户信息</td>
        </tr>
        <%
            }
        %>
        </tbody>
    </table>


    <div style="margin-top: 20px;">
        <button onclick="window.location.href='home.jsp'" class="btn back-btn">返回主页</button>
    </div>
</div>

</body>
</html>
